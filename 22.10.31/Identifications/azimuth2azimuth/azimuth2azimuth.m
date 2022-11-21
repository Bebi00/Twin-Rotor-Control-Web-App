%% Part 2  V7 -  Working for any na,nb,nk and degree m
clear
close all

%% data load

load("azimuth2azimuth_data.mat")
id = data.id;
val = data.val;

y_id = id.y;
u_id = id.u;

y_val = val.y;
u_val = val.u;

for na=1:4
    
    nb=na;
    nk = 0;
    %% The degree of the approximators
    m = 1:2;
    for degree = m % testing all the degrees from 1 to 30
        PHI_id = [];
        ARX_mat_id = [];
        for row=1:length(y_id)
            for col=1:na
                if(row-col <=0)
                    ARX_mat_id(row,col) = 0;
                else
                    ARX_mat_id(row,col) = -y_id(row-col);
                end
            end
            
            for col=na+1:na+nb
                if(row-col+na-nk <=0)
                    ARX_mat_id(row,col) = 0;
                else
                    ARX_mat_id(row,col) = u_id(row-col+na-nk);
                end
            end
        end
        
        %% Generating the power matrix which contains every combination of regressors
        No_values = length(ARX_mat_id(1,:));
        pow_mat = zeros(1,No_values);
        run=0;
        old_line = zeros(1,No_values);
        
        while (run < degree)
            
            new_line = old_line;
            new_line(end) = new_line(end)+1;
            for i=No_values-1:-1:1
                if(new_line(i+1) > degree)
                    new_line(i) = new_line(i)+1;
                    new_line(i+1) = 0;
                end
            end
            
            if sum(new_line) <= degree
                pow_mat(end+1,:) = new_line;
                run = new_line(1);
            end
            old_line = new_line;
            
        end
        
        
        %%  Computation of the regressors with the respective powers
        for k=1:length(ARX_mat_id(:,1))
            a = (ARX_mat_id(k,:).^pow_mat)';
            a  = cumprod(a);
            line = a(end,:);
            PHI_id=[PHI_id;line];
        end
        
        
        
        %%
        theta = PHI_id\y_id; % theta is calculated with the left division of matrix PHI
        % and Y containing all elements in a collumn
        
        y_hat_id{degree,na} = PHI_id*theta;
        % the approximated output is saved for each degree such that in the end we
        % can plot the best fittet function
        MSE_id(degree,na) = 1/length(y_hat_id{degree,na})*sum((y_hat_id{degree,na}-y_id).^2);
        
        %% Prediciton
        ARX_mat_pred = [];
        for row=1:length(y_val)
            for col=1:na
                if(row-col <=0)
                    ARX_mat_pred(row,col) = 0;
                else
                    ARX_mat_pred(row,col) = -y_val(row-col);
                end
            end
            
            for col=na+1:na+nb
                if(row-col+na-nk <=0)
                    ARX_mat_pred(row,col) = 0;
                else
                    ARX_mat_pred(row,col) = u_val(row-col+na-nk);
                end
            end
        end
        
        PHI_pred=[];
        
        for k=1:length(ARX_mat_pred(:,1))
            a = (ARX_mat_pred(k,:).^pow_mat)';
            a  = cumprod(a);
            line = a(end,:);
            PHI_pred=[PHI_pred;line];
        end
        
        y_hat_pred{degree,na} = PHI_pred * theta;
        MSE_prediction(degree,na) = 1/length(y_hat_pred{degree,na})*sum((y_hat_pred{degree,na}-y_val).^2);
        
        
        %% Simulation
        ARX_mat_sim = [];
        for row=1:length(y_val)
            ARX_line_sim = [];
            for col=1:na
                if(row-col <=0)
                    ARX_line_sim(col) = 0;
                else
                    ARX_line_sim(col) = -y_hat_simulation(row-col);
                end
            end
            
            for col=na+1:na+nb
                if(row-col+na-nk <=0)
                    ARX_line_sim(col) = 0;
                else
                    ARX_line_sim(col) = u_val(row-col+na-nk);
                end
            end
            PHI_line_sim = [];
            
            a = (ARX_line_sim.^pow_mat)';
            a  = cumprod(a);
            PHI_line_sim = a(end,:);
            
            y_hat_simulation(row,1) = PHI_line_sim*theta;
            ARX_mat_sim = [ARX_mat_sim; ARX_line_sim];
        end
        
        y_hat_sim{degree,na} = y_hat_simulation;
        MSE_simulation(degree,na) = 1/length(y_hat_sim{degree,na})*sum((y_hat_sim{degree,na}-y_val).^2);
        
    end
end
%% Best approximation for prediction

best_MSE_pred = min(min(MSE_prediction));
[best_MSE_pred_row,best_MSE_pred_col]=find(MSE_prediction == best_MSE_pred);

data_approx_pred = iddata(y_hat_pred{best_MSE_pred_row,best_MSE_pred_col},u_val,val.Ts);
data_approx_id = iddata(y_hat_id{best_MSE_pred_row,best_MSE_pred_col},u_id,id.Ts);
figure;compare(val,val,'-r',data_approx_pred);
title("Best Prediciton with na = nb = "+best_MSE_pred_col+" and degree m = "+best_MSE_pred_row);
figure;compare(id,id,'-r',data_approx_id);
title("Identification coresponding to the best Prediction")


%% Best approximation for simulation
best_MSE_sim = min(min(MSE_simulation));
[best_MSE_sim_row,best_MSE_sim_col]=find(MSE_simulation == best_MSE_sim);

data_approx_sim = iddata(y_hat_sim{best_MSE_sim_row,best_MSE_sim_col},u_val,val.Ts);
data_approx_id = iddata(y_hat_id{best_MSE_sim_row,best_MSE_sim_col},u_id,id.Ts);
figure;compare(val,val,'-r',data_approx_sim)
title("Best Simulation with na = nb = "+best_MSE_sim_col+" and degree m = "+best_MSE_sim_row);
figure;compare(id,id,'-r',data_approx_id);
title("Identification coresponding to the best Simulation")


