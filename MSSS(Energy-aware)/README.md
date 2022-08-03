## 代码运行说明
1. 在paint_Data.m文件中找到filename_set参数，其中“1111”的每一位分别代表w_Energy、w_Quality、w_Cost、w_Time的权重分配比例，“1111”代表权重均匀分配成4份，每份权重为0.25，“1011”代表权重均匀分配为3份，每份权重为0.333...
    ```matlab
    filename_set = [
               1111;
    %            1011;
    %            1101;
    %            1110;
    %            1100;
    %            1010;
    %            1001;
                ];
    ```
2. 在get_global_parameters.m文件中修改如下参数，使之与filename_set的值对应
    ```matlab
    w_Energy = 0.25;
    w_Quality = 0.25;
    w_Cost = 0.25;
    w_Time = 0.25;
    ```
3. 运行paint_Data.m文件生成数据
4. 依次修改filename_set为“1011”、“1101”、“1110”、“1100”、“1001”，重复1~3
5. 注释paint_Data.m中的如下代码
    ```matlab
    %% 生成M方法和M_E方法的目标值收敛数据，以及M_E方法的甘特图数据
    clear
    Main
    load('current_parameters2')
    movefile([source_Data_M, '.mat'], [objective_Data_M, '.mat'])
    movefile([source_Data_M_E, '.mat'], [objective_Data_M_E, '.mat'])
    ```
6. 运行paint_Data.m文件画出相应权重的目标函数收敛图、子任务调度甘特图、预热能耗和QoS满意度对比图