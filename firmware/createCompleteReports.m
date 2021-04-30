clc
clear all 
close all 

% Import DOM and  Report Libraries 
import mlreportgen.dom.*;
import mlreportgen.report.*;

display(newline)
display("---------------------MINTS---------------------")

addpath("../YAMLMatlab_0.4.3")
addpath("../functions/")
mintsDefinitions  = ReadYaml('mintsDefinitions.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/raw";
rawMatsFolder  =  dataFolder + "/rawMats";
% matsFolder     =  dataFolder + "/mats";


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)

display(newline)

doctype = "pdf"
rpt = Report("UTD Nodes",doctype)

%% Cover Page  
tp =  TitlePage("Title","UTD Nodes",...
    "SubTitle","Multi-scale Integrated Sensing and Simulation (MINTS)",...
    "Author","Laktha Wijeratne - MINTS",...
    "Image", "utdNode.png"...
     )

add(rpt,tp)

%% Table of Contents 

toc = TableOfContents;
add(rpt,toc)

for nodeIndex = 1: 2
    
    nodeID         = nodeIDs{nodeIndex}.nodeID;
    display(strcat("Loading UTD Node Data for : ", nodeID));
    loadName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'.mat');

    if exist(loadName)
        load(loadName);
        %% Creating Chapter for a given Node 
        ch = Chapter(strcat("NODE " +nodeID))
        
        % Adding Sections
        if sum(strmatch('OPCN2',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("OPC N2")
            % Add Figures 
             figOut1 = timeSeriesGraphReturn(mintsDataUTD.dateTime,...
                                            mintsDataUTD.OPCN2_pm1,...
                                            nodeID,...
                                            "Date Time","PM_{1}",...
                                             "PM_{1} Time Series");
        add(sc,Figure(figOut1));
        add(ch,sc);
      
                                         
        end 
        add(rpt,ch)
        delete(gcf);
    else 
        disply(strcat("No data for ",nodeID))
    end
    
    clearvars -except dataFolder rawMatsFolder ...
        nodeIDs timeSpan rpt...
        nodeIndex mintsDefinitions    
    
end 

close(rpt);
rptview(rpt);

