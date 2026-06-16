classdef MongoDbContainer < Container    
    properties

    end
    
    methods       
        function obj = MongoDbContainer(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj MongoDbContainer
            end

            obj@Container(network);
            obj.setNameInNetwork("mongo");
            obj.image = "mongo:5.0.10";
            obj.addEnvironment("MONGO_INITDB_ROOT_USERNAME: mongoAdmin");
            obj.addEnvironment("MONGO_INITDB_ROOT_PASSWORD: mongoPassword");
            obj.healthCheck = true;
        end
        
    end
end