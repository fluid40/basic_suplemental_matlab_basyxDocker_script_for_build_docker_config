classdef SmRegistryContainer < Container    
    properties

    end
    
    methods       
        function obj = SmRegistryContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj SmRegistryContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("sm-registry");
            obj.image = "eclipsebasyx/submodel-registry-log-mongodb:2.0.0-SNAPSHOT";
            obj.addEnvironment("- SERVER_PORT=8080");
            obj.addVolume("./server" + num2str(obj.network.count) + "/basyx/sm-registry.yml:/workspace/config/application.yml");
            obj.ports = "'" + num2str(9081 + 10 * obj.network.count) + ":8080'";
        end
        
    end
end