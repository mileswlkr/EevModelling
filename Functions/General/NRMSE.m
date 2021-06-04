function nrmsd = NRMSE(x_pred, x_meas)
% This function returns the Normalised Root Mean Squared Error (NRMSE).
% The average of the predicted values is used for normalisation, and the
% output is given as a percentage.
    xbar = mean(x_pred);
    nrmsd = sqrt(mean((x_pred - x_meas).^2))/xbar * 100;
end