classdef Container < handle & matlab.mixin.Heterogeneous
    
    properties
        image string
        containerName string
        environment string
        volumes string
        ports string
        network Network
        healthCheck logical
        dependsOn Container
    end
    
    methods
        function obj = Container(network)
            arguments(Input)
                network Network
            end
            arguments(Output)
                obj Container
            end
            obj.network = network;
            obj.environment = createArray(1,0, "string");
            obj.volumes = createArray(1,0, "string");
            obj.dependsOn = createArray(1,0,"Container");
            obj.healthCheck = false;
        end

        function setNameInNetwork(obj, name)
            arguments
                obj Container
                name string
            end
            obj.containerName = name + num2str(obj.network.count);
        end

        function addEnvironment(obj, newEnvironment)
            arguments
                obj Container
                newEnvironment string
            end
            obj.environment = [obj.environment, newEnvironment];
        end

        function addVolume(obj, newVolume)
            arguments
                obj Container
                newVolume string
            end
            obj.volumes = [obj.volumes, newVolume];
        end

        function addDependency(obj, depends)
            arguments
                obj Container
                depends Container
            end
            obj.dependsOn = [obj.dependsOn, depends];
        end

        function printInFile(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            fprintf(file, TextHelper.Spaces(2) + obj.containerName + ":\n");
            obj.printImage(file);
            obj.printContainerName(file);
            obj.printEnvironment(file);
            obj.printVolume(file);
            obj.printPorts(file);
            obj.printReStart(file);
            obj.printDependsOn(file);
            obj.printHealthCheck(file);
            obj.printNetwork(file);
        end
    end

    methods(Access=private)
        function printImage(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            if(~isempty(obj.image))
                fprintf(file, TextHelper.Spaces(4) + "image: " + obj.image + "\n");
            end
        end

        function printContainerName(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            if(~isempty(obj.image))
                fprintf(file, TextHelper.Spaces(4) + "container_name: " + obj.containerName + "\n");
            end
        end

        function printEnvironment(obj,file)
            arguments(Input)
                obj  Container
                file
            end
            if(isempty(obj.environment))
                return;
            end
            fprintf(file, TextHelper.Spaces(4) + "environment:\n");
            for i = 1:length(obj.environment)
                fprintf(file, TextHelper.Spaces(6) + obj.environment(i) + "\n");
            end
        end

        function printVolume(obj,file)
            arguments(Input)
                obj  Container
                file
            end
            if(isempty(obj.volumes))
                return;
            end
            fprintf(file, TextHelper.Spaces(4) + "volumes:\n");
            for i = 1:length(obj.volumes)
                fprintf(file, TextHelper.Spaces(6) + "- " + obj.volumes(i) + "\n");
            end
        end

        function printPorts(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            if(~isempty(obj.ports))
                fprintf(file, TextHelper.Spaces(4) + "ports: \n");
                fprintf(file, TextHelper.Spaces(6) + "- " + obj.ports + "\n");
            end
        end

        function printReStart(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            fprintf(file, TextHelper.Spaces(4) + "restart: no\n");
        end

        function printDependsOn(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            if(isempty(obj.dependsOn))
                return;
            end
            fprintf(file, TextHelper.Spaces(4) + "depends_on:\n");
            for i = 1:length(obj.dependsOn)
                fprintf(file, TextHelper.Spaces(6) + obj.dependsOn(i).containerName + ":\n");
                fprintf(file, TextHelper.Spaces(8) + "condition: service_healthy\n");
            end
        end

        function printHealthCheck(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            if(~obj.healthCheck)
                return;
            end
            fprintf(file, TextHelper.Spaces(4) + "healthcheck:\n");
            fprintf(file, TextHelper.Spaces(6) + "test: mongo\n");
            fprintf(file, TextHelper.Spaces(6) + "interval: 10s\n");
            fprintf(file, TextHelper.Spaces(6) + "timeout: 5s\n");
            fprintf(file, TextHelper.Spaces(6) + "retries: 5\n");
        end

        function printNetwork(obj, file)
            arguments(Input)
                obj  Container
                file
            end
            fprintf(file, TextHelper.Spaces(4) + "networks:\n");
            fprintf(file, TextHelper.Spaces(6) + "- nw-server"+ num2str(obj.network.count) +"\n");
        end
    end
end

