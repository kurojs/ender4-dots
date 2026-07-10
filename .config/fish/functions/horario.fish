function horario --description "Muestra el horario diario del plan 2026"
    clear

    set -l c_time (set_color cyan)
    set -l c_act (set_color white)
    set -l c_dur (set_color magenta)
    set -l c_note (set_color brcyan)
    set -l c_hdr (set_color yellow --bold)
    set -l r (set_color normal)

    # Column widths
    set -l act_w 38
    set -l dur_w 10

    function pad
        set -l target $argv[1]
        set -l text $argv[2]
        set -l vwidth (string length -V "$text")
        set -l spaces (math "$target - $vwidth")
        if test $spaces -gt 0
            printf "%s%*s" "$text" $spaces ""
        else
            printf "%s" "$text"
        end
    end

    echo ""
    echo $c_hdr"            🗓️  PLAN 2026 — Horario diario"$r
    echo "            ─────────────────────────────────────────────────────────────────────"
    echo ""

    for entry in \
        "08:00|Anki kanji + Radiko|30 min|20 kanji/día, cerebro fresco" \
        "08:30|Katas (2/día) + Radiko o stream devs|1h|Calentamiento lógica, listening pasivo" \
        "09:30|Libros japonés|1h 30min|Tettei 2pág · 500mon 2-6pág, concentración" \
        "11:00|Programación principal|2h|Proyectos · cursos · frameworks" \
        "13:00|L/M/V — Fitness + baño|1h 15min|Mar/Jue/Sab/Dom — Programación" \
        "14:15|Programación principal (continúa)|3h 45min|LinkedIn mar+vie (15min). Bloque más productivo" \
        "18:00|Manga + Yougisha X (lectura extensiva)|2h|Sin diccionario, flujo" \
        "20:00|Programación relajada + Radiko|1h|Cursos ligeros, refactoring, exploración" \
        "21:00|Anki minado del día|20 min|Solo cards nuevas del día, chill" \
        "21:20|YT japonés / curso ligero|Hasta d.|Para bajar ritmo" \
        "23:00|Dormir 🛌|9h|Hasta las 8:00am"

        set -l time (echo $entry | cut -d'|' -f1)
        set -l act (echo $entry | cut -d'|' -f2)
        set -l dur (echo $entry | cut -d'|' -f3)
        set -l desc (echo $entry | cut -d'|' -f4)

        set -l padded_act (pad $act_w $act)
        set -l padded_dur (pad $dur_w $dur)

        echo "  $c_time$time$r    $c_act$padded_act$r $c_dur$padded_dur$r $c_note$desc$r"
    end

    echo ""
    set_color brcyan
    echo "  Japonés activo: ~4h 20min/día · Programación: ~7h 45min/día"
    echo "  Fitness: L/M/V — 3 sesiones/semana"
    echo "  N1 julio 2027 · Ingeniero Full-Stack · Objetivo: \$60k MXN"
    set_color normal
    echo ""
end
