classdef (Hidden=true) ItemSet < handle
    %ItemSet Manage a number of homogeneous objects as a set, with a named key

    %   Copyright 2008-2011 The MathWorks, Inc.
    properties (GetAccess='protected',SetAccess='private')
        % The values that are accessed via the key
        Value

        % The key used to access those values
        Key
        
        % Allow Duplicate keys
        AllowDuplicateKeys
    end

    methods (Access='public')
        function [obj] = ItemSet(allowDuplicateKeys)
            narginchk(0,1)
            if nargin == 0
                allowDuplicateKeys = false;
            end
            % ItemSet create an set of items.
            obj.Key = {};
            obj.Value = {};
            obj.AllowDuplicateKeys = allowDuplicateKeys;
        end
        function addItem(obj,newKey,newValue)
            % ADDITEM: Add an item to the set
            % ADDITEM(NEWKEY,NEWVALUE) Adds NEWVALUE to the set under the
            % NEWKEY identifier.  NEWKEY must be a string, and must be
            % unique.
            narginchk(3,3)
            if ~ischar(newKey)
                error(message('instrument:ivicom:ItemSet:keyMustBeString'))
            end
            if ~obj.AllowDuplicateKeys && ~isempty(obj.findIndex(newKey))
                return;
            end
            if isempty(newValue)
                % No op if there's no value.
                return
            end
            obj.Key{end+1} = newKey;
            obj.Value{end+1} = newValue;
        end
        function [value] = getItem(obj,keyToFind)
            % GETITEM: Get an item from the set
            % GETITEM(KEYTOFIND) returns the value that matches the
            % KEYTOFIND.  If KEYTOFIND is not in the set, empty is
            % returned.
            narginchk(2,2)
            if ~ischar(keyToFind)
                error(message('instrument:ivicom:ItemSet:keyMustBeString'))
            end
            value=[];
            index = obj.findIndex(keyToFind);
            if ~isempty(index)
                value = obj.Value{index};
            end
        end
        function [value] = getItemByIndex(obj,index)
            % GETITEMBYINDEX: Get an item from the set
            % GETITEMBYINDEX(INDEX) returns the value that matches the
            % INDEX.  If INDEX is not in the set, empty is
            % returned.
            narginchk(2,2)
            if ~isnumeric(index)
                error(message('instrument:ivicom:ItemSet:indexMustBeNumeric'))
            end
            value =[];
            
            if index >0 && index  <= obj.getItemCount()
                value = obj.Value{index};
            end
            
        end
        function [keys] = getKeys(obj)
            % GETKEYS: Get all keys in the set
            % GETKEYS() returns all keys in the set.
            narginchk(1,1)
            keys = obj.Key;
        end
        function [count] = getItemCount(obj)
            % GETITEMCOUNT: Get the number of items in the set
            % GETITEMCOUNT() returns the count of items in the set.
            narginchk(1,1)
            count = length(obj.Key);
        end
        function removeItem(obj,keyToRemove)
            % REMOVEITEM: Remove an item from the set
            % REMOVEITEM(KEYTOREMOVE) removes the item with the KEYTOREMOVE
            % key from the set.  Attempts to remove a non-existent key will
            % error.
            narginchk(2,2)
            if ~ischar(keyToRemove)
                error(message('instrument:ivicom:ItemSet:keyMustBeString'))
            end
            indexToRemove = obj.findIndex(keyToRemove);
            if isempty(indexToRemove)
                error(message('instrument:ivicom:ItemSet:keyNotFound'))
            end

            % Remember when deleting cells from a cell array, you don't use {}
            obj.Key(indexToRemove)=[];
            obj.Value(indexToRemove)=[];
        end
        function itemFun(obj,fun)
            % ITEMFUN Apply a function to each item in the set
            %ITEMFUN(FUN) applies the function specified by FUN to
            %the contents of each item in the set.  
            %
            %FUN is function handle to a function of the form 
            % function(item) that is called repeatedly for each
            % member of the set. Note that you cannot
            %modify ITEM unless it is a handle object. Otherwise, all
            %modifications will be discarded.
            cellfun(fun,obj.Value);
        end
        function disp(obj,depth)
            if (nargin == 1)
                depth = 0;
            end
            for ii = 1:length(obj.Value)
                obj.Value{ii}.disp(depth)
            end
        end
    end
    methods (Access='private')
        function index = findIndex(obj,keyToFind)
            index = strmatch(keyToFind,obj.Key,'exact');
        end
    end
    methods (Hidden=true,Static=true,Access='public')
        function success = unitTest()
            mySet = instrument.ItemSet();
            mySet.addItem('x',10)
            mySet.addItem('y',3)
            mySet.addItem('z','foobar')
            try
                mySet.addItem(234,23)
                error(message('instrument:ivicom:ItemSet:keyStringTest'))
            catch e
                if ~strcmp(e.identifier,'ItemSet:addItem:keyMustBeString')
                    error(message('instrument:ivicom:ItemSet:keyStringTest'))
                end
            end

            if mySet.getItem('x') ~= 10 ||...
                    mySet.getItem('y') ~= 3 ||...
                    ~strcmp(mySet.getItem('z'),'foobar')
                error(message('instrument:ivicom:ItemSet:retrieveTest'))
            end

            if ~isempty(mySet.getItem('a'))
                error(message('instrument:ivicom:ItemSet:retrieveTest'))
            end

            if mySet.getItemCount() ~= 3
                error(message('instrument:ivicom:ItemSet:countTest'))
            end

            % Adding an empty should have no effect
            mySet.addItem('a',[])

            if mySet.getItemCount() ~= 3
                error(message('instrument:ivicom:ItemSet:addEmptyFailure'))
            end

            if ~all(strcmp(mySet.getKeys(),{'x','y','z'}))
                error(message('instrument:ivicom:ItemSet:getKeysTest'))
            end

            mySet.removeItem('y')

            if ~all(strcmp(mySet.getKeys(),{'x','z'})) ||...
                    mySet.getItemCount() ~= 2
                error(message('instrument:ivicom:ItemSet:removeTest'))
            end

            try
                mySet.removeItem('y')
                error(message('instrument:ivicom:ItemSet:removeInvalidTest'))
            catch e
                if ~strcmp(e.identifier,'ItemSet:removeItem:keyNotFound')
                    error(message('instrument:ivicom:ItemSet:removeInvalidTest'))
                end
            end

            mySet = instrument.ItemSet(true);
            mySet.addItem('x',5)
            try
                mySet.addItem('x',5)
            catch e
                if strcmp(e.identifier,'ItemSet:addItem:duplicateKey')
                    error(message('instrument:ivicom:ItemSet:duplicateKeyTest'))
                else
                    rethrow(e)
                end
            end
            if mySet.getItemCount() ~= 2
                error(message('instrument:ivicom:ItemSet:addFailure'))
            end
            
            %% Test the itemFun method
            summary = '';
            mySet.itemFun(@testItemFun);

            if ~strcmp(summary,'5,5,')
                error(message('instrument:ivicom:ItemSet:itemFunTest'))
            end
            
            success = 'Success';

            function testItemFun(item)
                summary = [summary num2str(item) ','];
            end
        end
    end
end
