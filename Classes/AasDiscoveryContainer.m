classdef AasDiscoveryContainer < Container    
    properties

    end
    
    methods       
        function obj = AasDiscoveryContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj AasDiscoveryContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("aas-discovery");
            obj.image = "eclipsebasyx/aas-discovery:2.0.0-SNAPSHOT-e961027";
            obj.addEnvironment("- SERVER_PORT=8081");
            obj.addVolume("./server" + num2str(obj.network.count) + "/basyx/aas-discovery.properties:/application/application.properties");
            obj.ports = "'" + num2str(8074 + 10 * obj.network.count) + ":8081'";
        end
        
    end
end