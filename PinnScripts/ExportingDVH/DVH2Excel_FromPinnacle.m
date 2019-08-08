function DVH_calculating_from_Pinnacle
%Usage: ��Ѱ�洢pinnacle�ƻ�ϵͳ����DVHĿ¼
%
DataDirPath = uigetdir('E:\dvhs');
DirList = dir(DataDirPath);
InstanceNum = length(DirList); %DVH����
CurrentData = struct([]);      %���������
for i = 1:InstanceNum          %���δ���ÿһ��dvh�ĵ�
    if strcmp('.',DirList(i,1).name) == 1 
    elseif strcmp('..',DirList(i,1).name)== 1
    else
        CurrentData{i,1} = DirList(i,1).name;        
        Currentfile = [DataDirPath,'\',char(DirList(i,1).name)];   %Current dvh·��     
        CurrentData{i,2} = ManufactingData(Currentfile);      %���ú�����������ݴ���CurrentData�ṹ��
    end
end
%            %����dvh.mat��
for i=3:length(CurrentData(:,1))
    CurrentData{i,1} = [CurrentData{i,1},'.xls'];       %excel ��׺xls
end
cd(DataDirPath);
[Flag] = mkdir(DataDirPath,'xls');                     %exceldata ����dir./xls
if Flag == 1
    cd([DataDirPath,'/xls']);
    for i=3:length(CurrentData(:,1))
        xlswrite(CurrentData{i,1},CurrentData{i,2});		%�洢Ϊ��Ӧxls�ĵ�
    end
else
    disp('save CurrentData to currentdir dvh.mat');
    save dvh.mat CurrentData;
end

disp('work done!!!');



function Output = ManufactingData(filename)  %����DVH�ٷֱ�

InputStruct = importdata(filename);    %���룬����struct
InputData = InputStruct.data;          %����
DataLength = length(InputData(:,1));   %���ݳ���
index = DataLength;                    %index�Ӵ�С
Output = zeros(DataLength,4);
Sum = 0;
Mark = 0;
TotalVol = sum(InputData(:,2));
while(index)
    if InputData(index,2) ~= 0     %���Maxdose��ʼλ��
        Mark = 1; 
        Sum = Sum + InputData(index,2);         
    end
    if Mark == 1;               
        Output(index,1) = InputData(index,1);
        Output(index,2) = InputData(index,2);
        Output(index,3) = Sum;                  %����ֵ
        Output(index,4) = Sum/TotalVol;         %�ٷֱ�
    else
        Output(index,1:2) = InputData(index,1:2); %ֱ�Ӹ���ǰ��������
    end
    index = index - 1; 
end
