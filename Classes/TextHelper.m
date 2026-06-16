classdef TextHelper
    methods(Static)
        function out = Spaces(count)
            arguments(Input)
                count int16
            end
            arguments(Output)
                out string
            end
            out = "";
            for i = 1:count
                out = out + " ";
            end
        end
    end
end

