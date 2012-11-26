function [E_v] = calcVisualQuality(H_err, blurr, block)

    % Constants:
    GAMMA = 0.45;
    ALPHA_M = 1.0;
    ALPHA_V = 1.0;
    
    % Obtain E_vm, incorrectness of motion model:
    E_vm = sum(H_err);
    
    % Obtain E_vv, visual quality distortion:
    E_vv = GAMMA*sum(block) + (1-GAMMA)*sum(blurr);

    % Calculate Visual Quality Measure:
    E_v = ALPHA_M*E_vm + ALPHA_V*E_vv;
    
end