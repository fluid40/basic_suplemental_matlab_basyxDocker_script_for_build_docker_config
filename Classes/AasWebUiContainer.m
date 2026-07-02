classdef AasWebUiContainer < Container    
    properties

    end
    
    methods       
        function obj = AasWebUiContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj AasWebUiContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("aas-web-ui");
            obj.image = "eclipsebasyx/aas-gui:SNAPSHOT-20260702-104713-e9f6e73";
            obj.addEnvironment("AAS_REGISTRY_PATH: http://localhost:" + num2str(9080+10*obj.network.count) + "/shell-descriptors");
            obj.addEnvironment("SUBMODEL_REGISTRY_PATH: http://localhost:" + num2str(9081+10*obj.network.count) + "/submodel-descriptors");
            obj.addEnvironment("AAS_REPO_PATH: http://localhost:" + num2str(8070+10*obj.network.count) + "/shells");
            obj.addEnvironment("SUBMODEL_REPO_PATH: http://localhost:" + num2str(8070+10*obj.network.count) + "/submodels");
            obj.addEnvironment("CD_REPO_PATH: http://localhost:" + num2str(8070+10*obj.network.count) + "/concept-descriptions");
            obj.addEnvironment("AAS_DISCOVERY_PATH: http://localhost:" + num2str(8074+10*obj.network.count) + "/lookup/shells");
            obj.addEnvironment("LOGO_PATH: logo.png");
            obj.addVolume("./server" + num2str(obj.network.count) + "/logo.png:/usr/src/app/dist/Logo/logo.png");
            obj.ports = "'" + num2str(8071 + 10 * obj.network.count) + ":3000'";
        end
        
    end
end