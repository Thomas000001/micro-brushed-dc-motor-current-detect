clear all;
arduino_current = serialport("COM5", 115200);



% 初始化存储数据的数组
timeValues = [];
currentValues = [];





% 实时数据绘图初始化
figure;
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ylabel('Current (mA)');
xlabel('Time (s)');
title('Current Data');
startTime = datetime('now');


% 使用一个标志来控制主循环
keepRunning = true;

% 使用 try-finally 结构确保在错误后正确关闭串行端口和保存数据
try
    while keepRunning
        if arduino_current.BytesAvailable > 0
            % 读取一行数据
            data = fgetl(arduino_current);

            % 查找并解析时间和电流值
            timeIdx = strfind(data, 'T:');
            currentIdx = strfind(data, 'C:');
            commaIdx = strfind(data, ',');

            if ~isempty(timeIdx) && ~isempty(currentIdx) && ~isempty(commaIdx)
                % 提取并转换电流值（忽略从Arduino传来的时间值）
                current = str2double(data(currentIdx + 2 : end));

                % 获取当前的实际时间戳
                xDataTime = seconds(datetime('now') - startTime);

                % 检查电流数据是否有效
                if ~isnan(current)
                    % 更新绘图
                    addpoints(h, xDataTime, current);
                    ax.XLim = [(xDataTime - 10) xDataTime];
                    %datetick('x', 'keeplimits', 'keepticks');->此為用來標記日期的
                    drawnow limitrate;  % 限制绘图更新速率

                    % 存储数据
                    timeValues = [timeValues; xDataTime];
                    currentValues = [currentValues; current];
                end


        end

        % 设置退出条件，例如按键退出
        if ~ishandle(h)
            keepRunning = false;
        end
        end
    end
catch ME
    disp('发生错误：');
    disp(ME.message);
end
plot(timeValues, currentValues)
xlabel('time(s)')
ylabel('current(mA)')
delete(arduino_current);
clear arduino_current;
mean(currentValues)