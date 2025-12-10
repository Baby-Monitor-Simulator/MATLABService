function Norm=plotNormStat(A,score)

for i=1:length(A)
Norm(:,i)=A(:,i)./sum(A(:,i));
end

figure
plot(score,Norm)