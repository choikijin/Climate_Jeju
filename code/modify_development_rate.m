function developmentrate = modify_development_rate(developmentrate)
    sz = size(developmentrate);
    if sz(1) ~= 1
        for k = 1:sz(1)
            for l = 1:sz(2)
                if developmentrate(k,l) < 0
                    developmentrate(k,l)=0;
                elseif developmentrate(k,l) >= 1
                    developmentrate(k,l)=1;
                end
            end
        end
    else
        for k = 1:sz(2)
            if developmentrate(k) < 0
                developmentrate(k) = 0;  
            elseif developmentrate(k)>= 1
                    developmentrate(k)=1;
            end
        end
    end
end