function [E_v] = calcVisualQuality(H_err, blurr, block)

    % Constants:
    gamma = 0.45;
    alpha_m = 1.0;
    alpha_v = 1.0;
    
    % Obtain E_vm, incorrectness of motion model:
    E_vm = sum(H_err);
    
    % Obtain E_vv, visual quality distortion:
    E_vv = gamma*sum(block) + (1-gamma)*sum(blurr);

    % Calculate Visual Quality Measure:
    E_v = alpha_m*E_vm + alpha_v*E_vv;
    
end