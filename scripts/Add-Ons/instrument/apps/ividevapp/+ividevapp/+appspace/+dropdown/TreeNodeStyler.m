classdef TreeNodeStyler < handle
    %TREENODESTYLER applies and removes ui styling to the tree or given
    %node.

    % Copyright 2023 The MathWorks, Inc.

    %% Style Properties
    properties (Constant)
        % Style element to bold the node
        BoldTextStyle = uistyle(FontWeight="bold")

        % Style Element to treat the node text as HTML text. This is needed
        % for highlighting the node.
        HTMLHighlightingStyle = uistyle("Interpreter","html");
    end

    %% HTML Highlighting and Wrapping
    properties (Constant)
        % Adds an HTML <mark> element to the node tex for highlighting
        Highlighter = @(markedText) ...
            "<mark style=""background-color: #ffd60a;"">" + markedText + "</mark>"

        % Wraps the node text in a <p> tag.
        HTMLWrapper = @(text) "<p>" + text + "</p>"
    end

    properties
        % Flag that enables or disables highlighting. Turning this to false
        % will stop all node highlighting (which might be needed to be
        % done for performance).
        HighlightingEnabled (1, 1) logical = true

        TreeHighlighted (1, 1) logical = false
    end

    properties (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        % Property that contains the Text to highlight for the given search
        % operation.
        TextToHighlight
    end

    %% PUBLIC APIs
    methods
        function boldFunctionsPropertiesNodes(~, tree)
            % Make the function and property nodes bold.

            addStyle(tree, ividevapp.appspace.dropdown.TreeNodeStyler.BoldTextStyle, "level", 1);
        end

        function highlightTreeNodes(obj, tree)
            % Make the node text to be HTML compatible.
            addStyle(tree, ividevapp.appspace.dropdown.TreeNodeStyler.HTMLHighlightingStyle);
            obj.TreeHighlighted = true;
        end

        function highlightMatchingNodes(obj, tree, node)
            % Highlight matching strings in the nodes. The highlighting
            % supports
            %
            % 1. Partial Matching - e.g. The substring "Time" will be
            % highlighted in "SomeTimeVal" when searching for "Time".
            %
            % 2. Case-insensitive Matching - e.g. The substring "Time" will be
            % highlighted in "SomeTimeVal" when searching for "time".
            %
            % 3. Multiple match highlighting - e.g. Both substrings "Time"
            % and "time" will be highlighted in "SometimeOutputTime" when
            % searching for "time".

            if ~obj.HighlightingEnabled
                return
            end

            try
                % Add the HTML styling to the node that needs to be
                % highlighted.

                if ~obj.TreeHighlighted
                    % The entire tree does not have uistyling enabled for
                    % HTML, only apply it to the node being processed
                    % currently.
                    addStyle(tree, ividevapp.appspace.dropdown.TreeNodeStyler.HTMLHighlightingStyle, ...
                        "node", node);
                end
                node.Text = getHTMLNodeText(obj, node.Text);
            catch
                % Do nothing - some exception that we didn't consider. Do
                % not break the app for this.
            end

            function text = getHTMLNodeText(obj, nodeName)
                % Returns the final HTML node text value that is going to
                % be assigned to the Node.Text field. This will enable the
                % highlighting to show in the tree.

                nodeName = string(nodeName);
                pattern = obj.TextToHighlight;

                % Split the node name into multiple chunks, split across
                % the matching pattern.
                [splitWords, matchedString] = split(nodeName, pattern);
                matchedStringLength = length(matchedString);

                highlightedText = "";

                % Create the node text using the results of the split
                % above. The matched strings are going to be wrapped in a
                % <mark> tag for them to be highlighted.
                for i = 1 : length(splitWords)
                    firstInstance = splitWords(i);
                    highlightedText = highlightedText + firstInstance;

                    if i > matchedStringLength
                        break
                    end
                    matchedInstance = ividevapp.appspace.dropdown.TreeNodeStyler.Highlighter(matchedString(i));
                    highlightedText = highlightedText + matchedInstance;
                end

                % Wrap the node text as <p>highlightedText<p>.
                text = ividevapp.appspace.dropdown.TreeNodeStyler.HTMLWrapper(highlightedText);
            end
        end

        function setTextToHighlight(obj, textToHiglight)
            % Set the search text entered by the user. As stated, this
            % class will do a case-insensitive matching of the search text
            % entered.

            obj.TextToHighlight = caseInsensitivePattern(textToHiglight);
        end

        function removeAllStyles(~, tree)
            % Remove all uistyles from the tree.

            removeStyle(tree);
        end
    end
end