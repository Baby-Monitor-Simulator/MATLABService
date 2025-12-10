classdef TokenReplacer
    %TOKENREPLACER Utility class replaces tokens in the MDD file that
    %cannot be read by MATLAB's readstruct API.
    % NOTE - there needs to be a 1-1 mapping for the following properties -
    % 1. TokensToReplaceInMDD
    % 2. CustomReplacedToken
    % 3. CodeRepresentationForToken

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Constant, Access = private)
        % Replaces these tokens when reading from the MDD File, because
        % these tokens cannot be parsed correctly using readstruct.
        TokensToReplaceInMDD = ["&#34;"]

        % Replaces "TokensToReplaceInMDD" with Custom Token.
        CustomReplacedToken = ["mwict-token-quotes"]

        % Actual representation of the token in text.
        CodeRepresentationForToken = [""""]

        TokenReplacements = dictionary(instrument.icdevice.internal.utility.TokenReplacer.TokensToReplaceInMDD, ...
            instrument.icdevice.internal.utility.TokenReplacer.CustomReplacedToken)

        TokenConverseReplacements = dictionary(instrument.icdevice.internal.utility.TokenReplacer.CustomReplacedToken, ...
            instrument.icdevice.internal.utility.TokenReplacer.CodeRepresentationForToken);
    end

    methods (Static)
        function mddText = replaceTokensInMDDWithCustomTokens(mddText)
            mddText = instrument.icdevice.internal.utility.TokenReplacer.performReplacement(mddText, ...
                "TokenReplacements");
        end

        function mddText = replaceCustomTokensInDriverWithCode(mddText)
            mddText = instrument.icdevice.internal.utility.TokenReplacer.performReplacement(mddText, ...
                "TokenConverseReplacements");
        end

        function mddText = customReplacement(mddText, textToReplace, replacedText)
            arguments
                mddText (1, 1) string
                textToReplace (1, :) string
                replacedText (1, :) string
            end
            mddText = mddText.replace(textToReplace, replacedText);
        end
    end

    methods (Static, Access = private)
        function text = performReplacement(text, mapName)
            arguments
                text (1, 1) string
                mapName (1, 1) string {mustBeMember(mapName, ["TokenReplacements", "TokenConverseReplacements"])}
            end

            import instrument.icdevice.internal.utility.TokenReplacer
            mapValue = TokenReplacer.(mapName);
            for k = keys(mapValue)'
                text = replace(text, k, mapValue(k));
            end
        end
    end

    %% PRIVATE CONSTRUCTOR
    methods (Access = private)
        function obj = TokenReplacer()
        end
    end
end
