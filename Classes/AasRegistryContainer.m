classdef AasRegistryContainer < Container    
    properties

    end
    
    methods       
        function obj = AasRegistryContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj AasRegistryContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("aas-registry");
            obj.image = "eclipsebasyx/aas-registry-log-mongodb:2.0.0-SNAPSHOT-e961027";
            obj.addEnvironment("- SERVER_PORT=8080");
            obj.addVolume("./server" + num2str(obj.network.count) + "/basyx/aas-registry.yml:/workspace/config/application.yml");
            obj.ports = "'" + num2str(9080 + 10 * obj.network.count) + ":8080'";
        end
        
    end
end