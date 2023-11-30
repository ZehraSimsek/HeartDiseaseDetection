function heart_disease_detection_GUI
    % Load data
    data = readtable('heart.csv');

    % Split data into inputs (features) and outputs (labels)
    features = data(:, 1:end-1);
    labels = data(:, end);

    % Convert table to array
    features = table2array(features);
    labels = table2array(labels);

    % Split data into training and test sets
    cv = cvpartition(size(data, 1), 'HoldOut', 0.3);
    idx = cv.test;
    XTrain = features(~idx, :);
    YTrain = labels(~idx, :);

    % Train a classification model
    mdl = fitcknn(XTrain, YTrain);

    % Create the main figure window
    f = figure('Visible', 'on', 'Position', [360, 500, 450, 360]);

    % Create UI controls
    hpredict = uicontrol('Style', 'pushbutton', 'String', 'Predict', ...
        'Position', [315, 280, 70, 25], 'Callback', @predictbutton_Callback);
  
    htext = uicontrol('Style', 'text', 'String', 'Enter patient data to predict heart disease:', ...
        'Position', [50, 315, 300, 15]);

    % Initialize the UI
    align([hpredict, htext], 'Center', 'None');
    disp('UI controls created');
    set(hpredict , 'Visible'  , 'on');
    set(htext , 'Visible'  , 'on');
    % Make the UI visible
    f.Visible = 'on';
    
    % Predict button callback function
    function predictbutton_Callback(source, eventdata)
        prompt = {'Age:', 'Gender:', 'Chest Pain Type:', ...
            'Resting Blood Pressure:', 'Cholesterol:', ...
            'Fasting Blood Sugar:', 'Resting ECG Results:', ...
            'Max Heart Rate Achieved:', 'Exercise Induced Angina:', ...
            'ST Depression Induced by Exercise:', ...
            'Slope of the Peak Exercise ST Segment:', ...
            'Number of Major Vessels Colored by Fluoroscopy:', ...
            'Thalassemia:'};
        dlgtitle = 'Patient Data';
        dims = [1 35];
        definput = {'0','0','0','0','0','0','0','0','0','0','0','0','0'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if ~isempty(answer)
            patient_data = str2double(answer');
            YPred = predict(mdl, patient_data);
            
            if YPred == 1
                msgbox('The patient is likely to have heart disease.')
            else
                msgbox('The patient is unlikely to have heart disease.')
            end
        end
    end

end