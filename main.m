clear, clc, close all;

addpath Classes\

path = dir;
path = path(1).folder;
path = path + "\basyx-multi-setup";

if ~isfolder(path)
    mkdir(path)
end

nNetworks = 5;

netWorks = createArray(1,nNetworks,"Network");

for i = 1:nNetworks
    netWorks(i) = Network();
    netWorks(i).Init(i);
end

outFile = fopen(path + "/docker-compose.yml", "w");

fprintf(outFile, "services:\n");

for i = 1:nNetworks
    netWorks(i).PrintContainersInFile(outFile);
    fprintf(outFile,"###########\n\n\n###########\n");
end

fprintf(outFile,"networks:");
for i = 1:nNetworks
  fprintf(outFile,"\n  nw-server" + num2str(i) + ":");
end

fclose(outFile);

for i = 1:nNetworks
    netWorks(i).createSuplemental(path);
end