classdef EnvironmentContainer < Container
    
    properties

    end
    
    methods
        function obj = EnvironmentContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj EnvironmentContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("aas-env");
            obj.image = "eclipsebasyx/aas-environment:2.0.0-SNAPSHOT-62bed8c";
            obj.addEnvironment("- SERVER_PORT=8081");
            obj.addVolume("./server" + num2str(obj.network.count) + "/aas:/application/aas");
            obj.addVolume("./server" + num2str(obj.network.count) + "/basyx/aas-env.properties:/application/application.properties");
            obj.ports = "'" + num2str(8070 + 10 * obj.network.count) + ":8081'";
        end
        
    end
end

