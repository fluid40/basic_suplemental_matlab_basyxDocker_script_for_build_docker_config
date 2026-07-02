classdef Network < handle
    
    properties
        environement EnvironmentContainer
        aasRegistry AasRegistryContainer
        smRegistry SmRegistryContainer
        aasDiscovery AasDiscoveryContainer
        mongoDb MongoDbContainer
        aasWebUi AasWebUiContainer
        count int16

    end
    
    methods
        function obj = Network()
            arguments(Output)
                obj Network
            end
        end

        function Init(obj, count)
            arguments(Input)
                obj Network
                count int16
            end
            obj.count = count;
            obj.environement = EnvironmentContainer(obj);
            obj.aasRegistry = AasRegistryContainer(obj);
            obj.smRegistry = SmRegistryContainer(obj);
            obj.aasDiscovery = AasDiscoveryContainer(obj);
            obj.mongoDb = MongoDbContainer(obj);
            obj.aasWebUi = AasWebUiContainer(obj);



            obj.environement.addDependency(obj.aasRegistry);
            obj.environement.addDependency(obj.smRegistry);
            obj.environement.addDependency(obj.mongoDb);

            obj.aasRegistry.addDependency(obj.mongoDb);

            obj.smRegistry.addDependency(obj.mongoDb);

            obj.aasDiscovery.addDependency(obj.mongoDb);

            obj.aasWebUi.addDependency(obj.environement);
        end

        function PrintContainersInFile(obj, file)
            obj.environement.printInFile(file);
            obj.aasRegistry.printInFile(file);
            obj.smRegistry.printInFile(file);
            obj.aasDiscovery.printInFile(file);
            obj.mongoDb.printInFile(file);
            obj.aasWebUi.printInFile(file);
        end

        function createSuplemental(obj, basePath)
            arguments
                obj Network
                basePath string
            end

            folderPath = basePath + "/server" + num2str(obj.count);
            if ~isfolder(folderPath)
                mkdir(folderPath)
            end

            aasFolderPath = folderPath + "/aas";
            if ~isfolder(aasFolderPath)
                mkdir(aasFolderPath)
            end

            basyxFolderPath = folderPath + "/basyx";
            if ~isfolder(basyxFolderPath)
                mkdir(basyxFolderPath)
            end

            obj.createAasDiscoveryProperties(basyxFolderPath);
            obj.createAasEnvironmentProperties(basyxFolderPath);
            obj.createAasRegistryYml(basyxFolderPath);
            obj.createSmRegistryYml(basyxFolderPath);

            obj.generateDummyLogo(folderPath);

        end
    end

    methods(Access=private)
        function createAasDiscoveryProperties(obj, path)
            arguments
                obj Network
                path string
            end

            outFile = fopen(path + "/aas-discovery.properties", "w");
            fprintf(outFile, ...
                "server.port=8081\n" + ...
                "spring.application.name=AAS Discovery Service\n" + ...
                "basyx.aasdiscoveryservice.name=aas-discovery-service\n" + ...
                "basyx.backend=MongoDB\n" + ...
                "basyx.cors.allowed-origins=*\n" + ...
                "basyx.cors.allowed-methods=GET,POST,PATCH,DELETE,PUT,OPTIONS,HEAD\n" + ...
                "spring.data.mongodb.host=mongo" + num2str(obj.count) + "\n"+...
                "spring.data.mongodb.database=aas-discovery\n" + ...
                "spring.data.mongodb.authentication-database=admin\n" + ...
                "spring.data.mongodb.username=mongoAdmin\n" + ...
                "spring.data.mongodb.password=mongoPassword" ...
            );
            fclose(outFile);
        end

        function createAasEnvironmentProperties(obj, path)
            arguments
                obj Network
                path string
            end

            outFile = fopen(path + "/aas-env.properties", "w");
            fprintf(outFile, ...
                "server.port=8081\n"  + ...
                "basyx.backend=MongoDB\n"  + ...
                "basyx.environment=file:aas\n"  + ...
                "basyx.cors.allowed-origins=*\n"  + ...
                "basyx.cors.allowed-methods=GET,POST,PATCH,DELETE,PUT,OPTIONS,HEAD\n"  + ...
                "basyx.aasrepository.feature.registryintegration=http://aas-registry" + num2str(obj.count) + ":8080\n"  + ...
                "basyx.submodelrepository.feature.registryintegration=http://sm-registry" + num2str(obj.count) + ":8080\n"  + ...
                "basyx.externalurl=http://localhost:" + num2str(8070 + 10*obj.count) + "\n"  + ...
                "spring.servlet.multipart.max-file-size=500MB\n"  + ...
                "spring.servlet.multipart.max-request-size=500MB\n"  + ...
                "spring.data.mongodb.host=mongo" + num2str(obj.count) + "\n"  + ...
                "spring.data.mongodb.database=aas-env\n"  + ...
                "spring.data.mongodb.authentication-database=admin\n"  + ...
                "spring.data.mongodb.username=mongoAdmin\n"  + ...
                "spring.data.mongodb.password=mongoPassword" ...
            );
            fclose(outFile);
        end

        function createAasRegistryYml(obj, path)
            arguments
                obj Network
                path string
            end

            outFile = fopen(path + "/aas-registry.yml", "w");
            fprintf(outFile, ...
                "basyx:\n"  + ...
                "  cors:\n"  + ...
                "    allowed-origins: '*'\n"  + ...
                "    allowed-methods: GET,POST,PATCH,DELETE,PUT,OPTIONS,HEAD\n"  + ...
                "spring:\n"  + ...
                "  mongodb:\n"  + ...
                "    uri: mongodb://mongoAdmin:mongoPassword@mongo" + num2str(obj.count) + ":27017" ...
            );
            fclose(outFile);
        end

        function createSmRegistryYml(obj, path)
            arguments
                obj Network
                path string
            end

            outFile = fopen(path + "/sm-registry.yml", "w");
            fprintf(outFile, ...
                "basyx:\n"  + ...
                "  cors:\n"  + ...
                "    allowed-origins: '*'\n"  + ...
                "    allowed-methods: GET,POST,PATCH,DELETE,PUT,OPTIONS,HEAD\n"  + ...
                "spring:\n"  + ...
                "  mongodb:\n"  + ...
                "    uri: mongodb://mongoAdmin:mongoPassword@mongo" + num2str(obj.count) + ":27017\n" ...
            );
            fclose(outFile);
        end

        function generateDummyLogo(obj, path)
            arguments
                obj Network
                path string
            end
            size = 50;
            color = rand(1,3);

            img = zeros(size,size,length(color));
            for i = 1:length(color)
                img(:,:,i) = color(i);
            end
            imwrite(img,path+"/logo.png")
        end
    end
end

