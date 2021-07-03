using Revise
using Connectomes
using GLMakie
using Colors

braak1 = [1006, 2006]
braak2 = [17, 53]
braak3 = [  1016,
            1007,
            1013,
            18,
            2016,
            2007,
            2013,
            54]
braak4 = [  1015,
            1002,
            1026,
            1023,
            1010,
            1035,
            1009,
            1033,
            2015,
            2002,
            2026,
            2023,
            2010,
            2035,
            2009,
            2033]
braak5 = [  1028,
            1012,
            1014,
            1032,
            1003,
            1027,
            1018,
            1019,
            1020,
            1011,
            1031,
            1008,
            1030,
            1029,
            1025,
            1001,
            1034,
            2028,
            2012,
            2014,
            2032,
            2003,
            2027,
            2018,
            2019,
            2020,
            2011,
            2031,
            2008,
            2030,
            2029,
            2025,
            2001,
            2034]
braak6 = [  1021,
            1022,
            1005,
            1024,
            1017,
            2021,
            2022,
            2005,
            2024,
            2017]
getbraak(braak) = [FS2Connectome[braak[i]] for i in 1:length(braak)]

b1 = getbraak(braak1)
b2 = getbraak(braak2)
b3 = getbraak(braak3)
b4 = getbraak(braak4)
b5 = getbraak(braak5)
b6 = getbraak(braak6)


cm=cgrad(:OrRd_9;alpha=collect(range(0.5,1.0;length=9)))

function plot_braak(braak, cm)
    f = Figure(resolution = (2500, 1000))
    for i in 1:length(braak)
        shift = 3 + (i)
        ax = Axis3(f[1,i], aspect = :data, azimuth = 0.0pi, elevation=-0.03pi)
        hidedecorations!(ax)
        hidespines!(ax)
        plot_cortex!(:all;colour=(:grey,0.05), transparent=true)
        for j in 1:i
            plot_roi!(braak[j], cm[shift-(j)])
        end
    end
    f
end

plot_braak([b1,b2,b3,b4,b5,b6], cm)