package com.babymonitoring.simulationplayer;

import com.babymonitoring.simulationplayer.controllers.MessageController;
import com.babymonitoring.simulationplayer.models.messages.CoordsMessage;
import com.babymonitoring.simulationplayer.models.results.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.mathworks.engine.MatlabEngine;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.List;
import java.util.ArrayList;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.springframework.scheduling.annotation.Async;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

public class Simulation {
    private static double timeIndex = 0;
    private static int simcount = 1;
    private static double prevTimeIndex = 0;
    private static MatlabEngine eng;
    private static Timer timer;
    private static XYSeries series;
    private static CompletableFuture<double[]> simPreResults;
    private static double[] simResults;
    private static boolean endSimulation = false;
    private MessageController controller;

    //@Autowired
    public Simulation(MessageController messageController) {
        this.controller = messageController;
    }

    public static CompletableFuture<double[]> getMatlabResultAsync(double a, double f, double ts, double tsp, double te) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Start de MATLAB-engine
                MatlabEngine eng = MatlabEngine.startMatlab();

                String projectDir = Paths.get("").toAbsolutePath().toString();
                String relativePath = projectDir + "\\src\\main\\resources\\scripts\\matlab";
                eng.eval("addpath('" + relativePath.replace("\\", "\\\\") + "')");

                double[] result = eng.feval("testscript", a, f, ts, tsp, te);
                eng.close();
                return result;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        });
    }

    public void Chart() {
        try {

            // Voer het script uit met invoer n = 4
            /*double a = 2;
            double f = 2;
            double ts = 0;
            double tsp = 0.01;
            double te = 10;*/

            series = new XYSeries("Sinusfunctie");
            XYSeriesCollection dataset = new XYSeriesCollection(series);
            JFreeChart chart = ChartFactory.createXYLineChart(
                    "Sinusbeweging",
                    "Tijd (s)",
                    "Amplitude",
                    dataset,
                    PlotOrientation.VERTICAL,
                    true, true, false
            );

            // Grafiek tonen in een JFrame
            JFrame frame = new JFrame("Sinus Grafiek");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.getContentPane().add(new ChartPanel(chart));
            frame.pack();
            frame.setVisible(true);

            JButton myButton = new JButton("Start Actie");
            frame.add(myButton, BorderLayout.SOUTH);

            myButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    System.out.println("Knop is ingedrukt!");
                    endSimulation = true;


                }
            });

            //startSimulation(10, 1000,5,0.5,0,0.01,10, UUID.randomUUID());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Async
    public static void stopSimulation() {
        timer.stop();
    }

    public static boolean simIsinRange(double y) {
        double top = 0;
        double bottom = -1;
        return y > bottom && y < top;
    }

    @Async
    public void startSimulation(int t, int steps, double a, double f, double ts, double tsp, double te, UUID userId) throws ExecutionException, InterruptedException {
        //----- For debug -----
        Chart();
        //---------------------


        simResults = getMatlabResultAsync(a, f, ts, tsp, te).get();
        timer = new Timer(t, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    double xCoord = timeIndex + prevTimeIndex;
                    double yCoord = simResults[(int) timeIndex];

                    //----- For debug -----
                    series.add(xCoord, yCoord); // Series.add( X-as, Y-as )
                    //---------------------

                    //----- WEBSOCKET -----
                    //controller.SendCoords(new CoordsMessage(userId, xCoord, yCoord));
                    //---------------------

                    timeIndex++;

                    if (timeIndex == 2) {
                        simPreResults = getMatlabResultAsync(a + simcount, f, ts, tsp, te);
                    }

                    if ((endSimulation || timeIndex >= steps)) {
                        if (simPreResults.isDone() && (simResults[(int) (timeIndex - 2)] < simResults[(int) (timeIndex - 1)]) && simIsinRange(simResults[(int) timeIndex])) {
                            endSimulation = false;
                            simcount++;
                            prevTimeIndex = timeIndex + prevTimeIndex;
                            timeIndex = 0;
                            simResults = simPreResults.get();
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });
        timer.start();
    }

    public static CompletableFuture<Object[]> getProductionMatlabResultAsync(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Start de MATLAB-engine
                MatlabEngine eng = MatlabEngine.startMatlab();

                String projectDir = Paths.get("").toAbsolutePath().toString();
                String relativePath = projectDir + "\\src\\main\\resources\\scripts\\matlab\\production";
                eng.eval("addpath('" + relativePath.replace("\\", "\\\\") + "')");

                Object[] result = eng.feval("FMPmodel", vMother ? 1 : 0, vUterus ? 1 : 0, vFoetus ? 1 : 0, vUmbilical, vBrain ? 1 : 0, vCAVmodel, vScen, vHES ? 1 : 0, vPersen ? 1 : 0, vDuty ? 1 : 0, vNCycleMax, vLamb ? 1 : 0);
                eng.close();
                return result;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        });
    }

    @Async
    public void startProductionSimulation(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb, UUID userId) throws ExecutionException, InterruptedException {
        //----- For debug -----
        //Chart();
        //---------------------


        Object[] tempSimResults = getProductionMatlabResultAsync(vMother, vUterus, vFoetus, vUmbilical, vBrain, vCAVmodel, vScen, vHES, vPersen, vDuty, vNCycleMax, vLamb).get();

        //------------------------ Use output to make new results ------------------------
        Object[] pUt = (Object[]) tempSimResults[0];
        double[] pUtT = (double[]) pUt[0];
        double[] pUtV = (double[]) pUt[1];
        UPResult[] upResults = new UPResult[pUtT.length];
        for (int i = 0; i < pUtT.length; i++) {
            UPResult upResult = new UPResult(pUtT[i], pUtV[i]);
            upResults[i] = upResult;
        }

        //Just here if we need it
        /*
        Object[] qUt = (Object[]) tempSimResults[1];
        double[] qUtT = (double[]) qUt[0];
        double[] qUtV = (double[]) qUt[1];
        FHRResult fhrResult = new FHRResult(qUtT, qUtV);
        */

        Object[] pAo = (Object[]) tempSimResults[2];
        double[] pAoT = (double[]) pAo[0];
        double[] pAoV = (double[]) pAo[1];
        O2PResult[] o2PResults = new O2PResult[pAoT.length];
        for (int i = 0; i < pAoT.length; i++) {
            O2PResult o2PResult = new O2PResult(pAoT[i], pAoV[i]);
            o2PResults[i] = o2PResult;
        }

        Object[] MAP = (Object[]) tempSimResults[3];
        double[] MAPT = (double[]) MAP[0];
        double[] MAPV = (double[]) MAP[1];
        MAPResult[] mapResults = new MAPResult[MAPT.length];
        for (int i = 0; i < MAPT.length; i++) {
            MAPResult mapResult = new MAPResult(MAPT[i], MAPV[i]);
            mapResults[i] = mapResult;
        }

        Object[] FHR = (Object[]) tempSimResults[4];
        double[] FHRT = (double[]) FHR[0];
        double[] FHRV = (double[]) FHR[1];
        FHRResult[] fhrResults = new FHRResult[FHRT.length];
        for (int i = 0; i < FHRT.length; i++) {
            FHRResult fhrResult = new FHRResult(FHRT[i], FHRV[i]);
            fhrResults[i] = fhrResult;
        }
        FMPResult fmpResult = new FMPResult(fhrResults, mapResults, o2PResults, upResults);
        //--------------------------------------------------------------------------------


        //------------------ Send CoordsMessage to the websocket through the controller ------------------
        FMPResult[] results = SplitList(500,CorrectResults(fmpResult));
        for (int i = 0; i < results.length; i++) {
            controller.SendCoords(new CoordsMessage(userId, results[i]));
        }
        //------------------------------------------------------------------------------------------------
    }

    /**
     * Method which removes unnecessary amounts of data
     *
     * @param fmpResult The FMPResult class from your MatLab data
     * @return FMPResult with possible removed data
     */
    private FMPResult CorrectResults (FMPResult fmpResult) {
        double timeSpanDif = 0.1;
        double uPressureDif = 0.1;


        double timeSpan = 0;
        double uPressure = 0;
        List<UPResult> newList = new ArrayList<>();

        for (int i = 0; i < fmpResult.upResult.length; i++) {
            UPResult result = fmpResult.upResult[i];
            if (i != 0 && i < (fmpResult.upResult.length - 1)) {
                if ((timeSpan + timeSpanDif) < result.timeSpan) { //If timespan difference is big enough
                    newList.add(result);
                    timeSpan = result.timeSpan;
                    uPressure = result.uPressure;
                }
                else if ((uPressure + uPressureDif) < result.uPressure) { //If pressure difference is big enough
                    newList.add(result);
                    timeSpan = result.timeSpan;
                    uPressure = result.uPressure;
                }
            }
            else if (i != 0) { //If pressure isn`t big enough
                newList.add(result);
                timeSpan = result.timeSpan;
                uPressure = result.uPressure;
            }
            else { //If first value
                timeSpan = result.timeSpan;
                uPressure = result.uPressure;

                newList.add(fmpResult.upResult[i]);
            }
        }

        fmpResult.upResult = newList.toArray(new UPResult[0]);

        return fmpResult;
    }

    /**
     * Method which splits one FMPResult into multiple if needed.
     *
     * @param arraySize The maximum size for the new arrays
     * @param fmpResult The FMPResult class from corrected
     * @return FMPResult array with split FMPResults
     */
    private FMPResult[] SplitList(double arraySize, FMPResult fmpResult) {
        int length = 1;

        //------------------------ Check for amount of messages ------------------------
        double UPCeil = Math.ceil((double) fmpResult.upResult.length / arraySize);
        if (UPCeil > length) length = (int) UPCeil;

        double O2PCeil = Math.ceil((double) fmpResult.o2PResult.length / arraySize);
        if (O2PCeil > length) length = (int) O2PCeil;

        double MAPCeil = Math.ceil((double) fmpResult.mapResult.length / arraySize);
        if (MAPCeil > length) length = (int) MAPCeil;

        double FHRCeil = Math.ceil((double) fmpResult.fhrResult.length / arraySize);
        if (FHRCeil > length) length = (int) FHRCeil;
        //------------------------------------------------------------------------------

        FMPResult[] fmpResultExport = new FMPResult[length];
        int index = 0;
        List<UPResult> upResults = new ArrayList<>();
        List<O2PResult> o2pResults = new ArrayList<>();
        List<MAPResult> mapResults = new ArrayList<>();
        List<FHRResult> fhrResults = new ArrayList<>();

        //------------------------ A for loop for the max length of the arrays ------------------------
        for (int i = 0; i < length * arraySize; i++) {
            if (i == arraySize) {
                fmpResultExport[index] = new FMPResult();
                fmpResultExport[index].upResult = upResults.toArray(new UPResult[0]);
                fmpResultExport[index].o2PResult = o2pResults.toArray(new O2PResult[0]);
                fmpResultExport[index].mapResult = mapResults.toArray(new MAPResult[0]);
                fmpResultExport[index].fhrResult = fhrResults.toArray(new FHRResult[0]);

                upResults = new ArrayList<>();
                o2pResults = new ArrayList<>();
                mapResults = new ArrayList<>();
                fhrResults = new ArrayList<>();

                index++;
            }
            if (i < fmpResult.upResult.length) {
                upResults.add(fmpResult.upResult[i]);
            }
            if (i < fmpResult.o2PResult.length) {
                o2pResults.add(fmpResult.o2PResult[i]);
            }
            if (i < fmpResult.mapResult.length) {
                mapResults.add(fmpResult.mapResult[i]);
            }
            if (i < fmpResult.fhrResult.length) {
                fhrResults.add(fmpResult.fhrResult[i]);
            }
        }
        //----------------------------------------------------------------------------------------------
        fmpResultExport[index] = new FMPResult();
        fmpResultExport[index].upResult = upResults.toArray(new UPResult[0]);
        fmpResultExport[index].o2PResult = o2pResults.toArray(new O2PResult[0]);
        fmpResultExport[index].mapResult = mapResults.toArray(new MAPResult[0]);
        fmpResultExport[index].fhrResult = fhrResults.toArray(new FHRResult[0]);

        return fmpResultExport;
    }
}