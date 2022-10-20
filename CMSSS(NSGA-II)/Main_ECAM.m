%% ���빦�ܣ����������ݼ��У����������ϵ�����ѡ���޷���ռ�õ������������ָ��Ϊ��Time������ʱ��)��Cost������ɱ�����Q������������
tic
clear
clc

global_parameters_block 
load('weight_current') % ��ȡQuality��Cost��Time��Ȩ��

%% �㷨����
Individual_best = zeros(gen_max,subtask_num); % ÿһ�������Ÿ����ű���
Individual_best_Start_candidate_service = zeros(gen_max,subtask_num); % ÿһ�������Ÿ���ķ���ʼʱ��
Individual_best_End_candidate_service = zeros(gen_max,subtask_num); % ÿһ�����Ÿ���ķ������ʱ��
Individual_best_Start_logistic = zeros(gen_max,subtask_num); % ÿһ�����Ÿ����������ʼʱ��
Individual_best_End_logistic = zeros(gen_max,subtask_num); % ÿһ�����Ÿ������������ʱ��
Individual_best_Fitness = zeros(gen_max,1); % ÿһ�����Ÿ������Ӧ��ֵ

Populations = cell(gen_max,1); % ��Ÿ�����Ⱥ����
Populations_front_num = cell(gen_max,1); % ��Ÿ�����Ⱥ�����ǰ�ر��
Populations_Fitness_value = cell(gen_max,1); % ��Ÿ�����Ⱥ�����Ŀ��ֵ
Populations_front = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ���
Populations_front_Fitness_value = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ����Ŀ��ֵ
Populations_front_Start_candidate_service = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ���ķ���ʼʱ��
Populations_front_End_candidate_service = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ���ķ������ʱ��
Populations_front_Start_logistics = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ����������ʼʱ��
Populations_front_End_logistics = cell(gen_max,1); % ��Ÿ�����Ⱥ��ǰ�ظ������������ʱ��
% ����ѭ������
gen = 1;

%% ��Ⱥ�����ʼ��
Population = randi(candidate_service_num, population_size, subtask_num);

while(gen <= gen_max)
    %% �Ż�����
    Population_crossed = cross(Population,cross_probability); % ����
    Population_mutated = mutate(Population,mutation_probability,candidate_service_num); % ����
    Population_combined = combine(Population,Population_crossed,Population_mutated); % �ϲ�ԭʼ�����桢������Ⱥ�ĸ���
    
    %% ��Population_combined��Ⱥ���е���
    [Tl,Cl] = logistics(Population_combined,Distance_cell,T_unit_dist,C_unit_dist);% ������Ⱥ��ÿ�����������ʱ��������ɱ�
    [Start_candidate_service,End_candidate_service] = scheduling_Makespan_Energy(Population_combined,Th,Tc,Ts,Idle,ordertime,Time_required_max,Tl); % ������Ⱥ��ÿ�������к�ѡ��������������ʱ��
    [Start_logistics,End_logistics] = Start_End_logistics(End_candidate_service,Tl); % ������Ⱥ��ÿ�������Ӧ������������俪ʼʱ����������ʱ��
    
    %% ����Population_combined��Ⱥ���ϲ���Ӧ�ȣ�Provider��Energy��
    E = preheating_energy(Eh,Population_combined,Th,Tc,Idle,Start_candidate_service,End_candidate_service); % ����ѡ�����ʵ��Ԥ���ܺ�
    Energy = sum(E,2); % ��Ⱥ�и�����ܵ�ʵ��Ԥ���ܺ�
    Energy_dimensionless = dimensionless_Energy(Energy,Energy_max); % ���ܵ�ʵ��Ԥ���ܺĽ��������ٻ�
    Fitness_top = fitness_Energy(Energy_dimensionless); % �ϲ���Ӧ��ֵ
    
    %% ����Population_combined��Ⱥ�ĵײ���Ӧ�ȣ�Demander��Time��Cost��Quality��
    [Quality,Cost,Time] = criteria(Population_combined,Q,Cs,End_candidate_service,Cl); % ��ȡ��Ⱥ��ÿ�������Ӧ�������������ɳɱ������ʱ��
    [Quality_dimensionless,Cost_dimensionless,Time_dimensionless] = dimensionless_QoS(Quality,Cost,Time,Time_required_max,Cost_required_max,Quality_required_min,Time_min,Cost_min,Quality_max); % ���������ٻ�
    Fitness_bottom = fitness_QoS(Quality_dimensionless,Cost_dimensionless,Time_dimensionless,w_Quality,w_Cost,w_Time); % �ײ���Ӧ�Ⱥ���ֵ

    %% ����Population_combined��paretoǰ�ر��
    Fitness_value = [Fitness_top';Fitness_bottom']'; % �����Ⱥ�и����Ŀ��ֵ
    Inf_index = find(Fitness_value(:,2)==inf); % �ҵ��²�Ŀ��Ϊ��������
    Fitness_value(Inf_index,1) = Inf; % ���²�Ŀ��Ϊ�������е��ϲ�Ŀ��Ҳ��Ϊ�����
    front_num = pareto_front(Fitness_value); % ������Ⱥ�и���Ŀ��ֵ��������ǰ�ر��
    
    %% ѡ����һ����ȺPopulation��Population_combined��Ⱥ�е�λ��index
    [Population_index,front_index] = select_population(Fitness_value,front_num,population_size);
    
    %% ��ȡ��Ⱥ��Ϣ
    Population = Population_combined(Population_index,:); % ��һ����Ⱥ
    Population_front_num = front_num(Population_index,:); % ��һ����Ⱥ��ǰ�ر��
    Population_Fitness_value = Fitness_value(Population_index,:); % ��һ����Ⱥ��Ŀ��ֵ
    
    %% ��ȡ��Ⱥǰ����Ϣ
    Population_front = Population_combined(front_index,:); % ��һ����Ⱥ��ǰ�ظ���
    Population_front_Fitness_value = Fitness_value(front_index,:); % ��һ����Ⱥ��ǰ�ظ����Ŀ��ֵ
    Population_front_Start_candidate_service = Start_candidate_service(front_index,:);
    Population_front_End_candidate_service = End_candidate_service(front_index,:);
    Population_front_Start_logistics = Start_logistics(front_index,:);
    Population_front_End_logistics = End_logistics(front_index,:);

    %% ���������Ⱥ�������Ϣ
    Populations{gen,1} = Population; % ��Ⱥ����
    Populations_front_num{gen,1} = Population_front_num; % ��Ⱥ�����ǰ�ر��
    Populations_Fitness_value{gen,1} = Population_Fitness_value; % ��Ⱥ�����Ŀ��ֵ
    %% ���������Ⱥǰ�ظ������Ϣ
    Populations_front{gen,1} = Population_front; % ��Ⱥ��ǰ�ظ���
    Populations_front_Fitness_value{gen,1} = Population_front_Fitness_value; % ��Ⱥ��ǰ�ظ����Ŀ��ֵ
    Populations_front_Start_candidate_service{gen,1} = Population_front_Start_candidate_service; % ��Ⱥ��ǰ�ظ���ķ���ʼʱ��
    Populations_front_End_candidate_service{gen,1} = Population_front_End_candidate_service; % ��Ⱥ��ǰ�ظ���ķ������ʱ��
    Populations_front_Start_logistics{gen,1} = Population_front_Start_logistics; % ��Ⱥ��ǰ�ظ����������ʼʱ��
    Populations_front_End_logistics{gen,1} = Population_front_End_logistics; % ��Ⱥ��ǰ�ظ������������ʱ��
    
    %% ���´���
    gen = gen + 1;
    disp(gen);
end
toc
%% ������Ⱥ��������ǰ��ͼ
% paint_pareto_dynamically(Populations_front_num,Populations_Fitness_value,gen_max);

%% ��ȡ���һ����Ⱥ��ǰ����Ϣ
Population_front_last = Populations_front{gen_max,1}; % ���һ����Ⱥ��ǰ�ظ���
Population_front_last_Fitness_value = Populations_front_Fitness_value{gen_max,1}; % ���һ����Ⱥ��ǰ��Ŀ��ֵ
Population_front_last_Start_candidate_service = Populations_front_Start_candidate_service{gen_max,1}; % ���һ����Ⱥ��ǰ�ظ���ķ���ʼʱ��
Population_front_last_End_candidate_service = Populations_front_End_candidate_service{gen_max,1}; % ���һ����Ⱥ��ǰ�ظ���ķ������ʱ��
Population_front_last_Start_logistics = Populations_front_Start_logistics{gen_max,1}; % ���һ����Ⱥ��ǰ�ظ����������ʼʱ��
Population_front_last_End_logistics = Populations_front_End_logistics{gen_max,1}; % ���һ����Ⱥǰ�ظ������������ʱ��
%% ѡ���һ�����弰���������
Individual = Population_front_last(1,:); % ���һ����Ⱥ��ǰ�ظ����еĵ�һ������
Individual_Start_candidate_service = Population_front_last_Start_candidate_service(1,:);
Individual_End_candidate_service = Population_front_last_End_candidate_service(1,:);
Individual_Start_logistics = Population_front_last_Start_logistics(1,:);
Individual_End_logistics = Population_front_last_End_logistics(1,:);
%% ��������ĸ���ͼ
% paint_gantt(Individual,Occupancy,Time_elasticity,Individual_Start_candidate_service,Individual_End_candidate_service,Individual_Start_logistics,Individual_End_logistics);
save('Data_ECAM.mat');