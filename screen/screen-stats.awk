#! /usr/bin/awk -f

BEGIN {
    cpufile = "/proc/stat";
    memfile = "/proc/meminfo";
    uptimefile = "/proc/uptime";

    cpu_period = 2;
    uptime_period = 60;
    uptime_counter = 0;
    updates_downcounter = 0;
    updates_command = "aptitude search ~U -F %p --disable-columns | wc -l";

    while (1) {
        # updates
        if (updates_downcounter == 0) {
            nexttime = mktime(strftime("%Y %m %d") " 09 00 00");
            if (nexttime < systime())
                nexttime += 24*3600;
            updates_downcounter = int((nexttime - systime()) / cpu_period);
            updates_command | getline updates;
            if (updates == 0)
                updates = "up-to-date"
            else
                updates = "\005{Y}" updates "\005{-} updates"
            close(updates_command);
        }
        updates_downcounter--;

        # cpu
        getline < cpufile;
        u=$2-up; n=$3-np; s=$4-sp; i=$5-ip; w=$6-wp; q=$7-qp; f=$8-fp;
        cpu = sprintf("%3.0f",(u+n+s)/(u+n+s+i+w+q+f)*100);
        up=$2;np=$3;sp=$4;ip=$5;wp=$6;qp=$7;fp=$8;
        close(cpufile);

        # memory
        avail = -1; cached = -1; buffers = 0;
        while (avail == -1 && cached == -1) {
            getline < memfile;
            if ($1 == "MemTotal:")     total=$2;
            if ($1 == "MemFree:")      free=$2;
            if ($1 == "MemAvailable:") avail=$2;
            if ($1 == "Buffers:")      buffers=$2;
            if ($1 == "Cached:")       cached=$2;
        }
        if (avail == -1)
            avail = free + buffers + cached;
        mem = sprintf("%.0f", (total - avail) / total * 100);
        close(memfile);

        # uptime
        if (uptime_counter * cpu_period == uptime_period)
            uptime_counter = 0;
        if (uptime_counter == 0) {
            getline < uptimefile
            if ($1 > 86400)
                uptime = sprintf("\005{Y}%d\005{-}d \005{Y}%d\005{-}h", $1/86400, $1%86400/3600);
            else if ($1 > 3600)
                uptime = sprintf("\005{Y}%d\005{-}h \005{Y}%d\005{-}m", $1/3600, $1%3600/60);
            else
                uptime = sprintf("\005{Y}%d\005{-}m", $1/60);
            close(uptimefile);
        }
        uptime_counter++;

        printf "%s \005{w}|\005{-} cpu\005{Y}%s\005{-}%% \005{w}|\005{-} mem \005{Y}%s\005{-}%% \005{w}|\005{-} up %s\n", updates, cpu, mem, uptime;

        if (system(sprintf("sleep %d", cpu_period)) != 0)
            break
    }
    exit
}
