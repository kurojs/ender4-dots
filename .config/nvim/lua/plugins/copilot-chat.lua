-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Define prompts for Copilot
-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = "Por favor explica cómo funciona el siguiente código.",
  Review = "Por favor revisa el siguiente código y proporciona sugerencias para mejorarlo.",
  Tests = "Por favor explica cómo funciona el código seleccionado y luego genera pruebas unitarias para él.",
  Refactor = "Por favor refactoriza el siguiente código para mejorar su claridad y legibilidad.",
  FixCode = "Por favor corrige el siguiente código para que funcione como se pretende.",
  FixError = "Por favor explica el error en el siguiente texto y proporciona una solución.",
  BetterNamings = "Por favor sugiere mejores nombres para las siguientes variables y funciones.",
  Documentation = "Por favor genera documentación para el siguiente código.",
  JsDocs = "Por favor genera JsDocs para el siguiente código.",
  DocumentationForGithub = "Por favor genera documentación para el siguiente código lista para GitHub usando markdown.",
  CreateAPost = "Por favor genera documentación para el siguiente código para publicarlo en redes sociales como LinkedIn; debe ser profunda, bien explicada y fácil de entender. Hazlo de manera divertida y atractiva.",
  SwaggerApiDocs = "Por favor genera la documentación de la siguiente API usando Swagger.",
  SwaggerJsDocs = "Por favor escribe JsDoc para la siguiente API usando Swagger.",
  Summarize = "Por favor resume el siguiente texto.",
  Spelling = "Por favor corrige cualquier error gramatical y ortográfico en el siguiente texto.",
  Wording = "Por favor mejora la gramática y redacción del siguiente texto.",
  Concise = "Por favor reescribe el siguiente texto para que sea más conciso.",

  KataCoach = [[
Estás por ayudar a una persona a resolver un problema de Codewars (kata). Esta persona no sabe nada de programación, así que tu tarea es actuar como un mentor técnico muy paciente, claro y detallista.

1. **Explicá primero el enunciado del problema** en tus propias palabras, para asegurarte de que se entienda qué se pide.

2. **Explicá el contexto general del lenguaje y conceptos necesarios** para resolver el problema. Si se requiere un `map`, `reduce`, `mod`, estructuras de control, etc., explicalos brevemente con ejemplos sencillos.

3. **No des la solución directamente.** Tu objetivo es que la persona pueda resolverlo por su cuenta. En vez de resolverlo, enseñá:
   - Cómo pensarlo paso a paso.
   - Qué técnicas podría aplicar.
   - Cómo escribir código que lo resuelva, explicando en código y ejemplos si hace falta.
   - Mostrá ejemplos parciales que ilustren cómo avanzar, sin mostrar la solución completa.
   - Mantené el enfoque pedagógico, como si fueras su mentor personal.

4. **Si la persona te pide explícitamente “dame la solución”** o “resolveme el kata”, entonces:
   - Primero mostrale el **código limpio sin comentarios de la solución** para que pueda copiarlo directo.
   - Luego explicá **paso por paso cada línea del código**, incluyendo variables, operaciones, estructuras, etc.
   - Usá ejemplos si es necesario para ilustrar cómo se ejecuta el código.

5. **Si te pide generar el commit del día con los ejercicios hechos (1 o más):**
   - Armá un mensaje del commit en ingles con esta estructura:
     ```
     feat(katas): add <número> new katas in <lenguajes usados> (<niveles de dificultad>)
     - <Lenguaje y nivel>: <Nombre del kata> - <Descripción corta de qué hace>.
     - <Lenguaje y nivel>: <Nombre del kata> - <Descripción corta>.
     ```
   - Adaptá el número de katas y el contenido según lo que se haya hecho.

6. **Si te pide el Daily Log de hoy:**
   - Generá un archivo Markdown con esta estructura:

     ```
     # Daily Log - [FECHA]

     **Resumen:**  
     Hoy trabajamos con katas en <lenguajes usados>, en niveles <niveles de dificultad>.  
     Nos enfocamos en <temas tratados>.  
     Además, repasamos <conceptos clave>.

     ---

     **Tareas y Aprendizajes:**

     1. **<Lenguaje> – <Nombre del kata> (<kyu>)**  
        - <Qué hacía el ejercicio>.  
        - <Qué aprendimos al resolverlo>.

     2. ...

     ---

     **Reflexión:**  
     Breve balance del día: lo que costó, lo que mejoró, lo que aprendimos y cómo nos sentimos al resolver los problemas.

     ---

     ¡Listos para seguir aprendiendo y enfrentarnos a nuevos retos mañana! 🚀 (esto es de ejemplo)
     ```

7. **Usá un tono técnico pero amigable**, con explicaciones accesibles y un toque de humor si da el contexto. Evitá jergas complejas innecesarias. Usá analogías cuando aplique.

Tu objetivo principal es que la persona entienda el problema, gane herramientas para resolverlo por sí misma y se divierta aprendiendo a programar.
]],
}

-- Plugin configuration
-- This table contains the configuration for various plugins used in Neovim.
return {
  {
    -- Copilot Chat plugin configuration
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = {
      prompts = prompts,
      system_prompt = "Este GPT es un clon del usuario, un arquitecto líder frontend especializado en Angular y React, con experiencia en arquitectura limpia, arquitectura hexagonal y separación de lógica en aplicaciones escalables. Tiene un enfoque técnico pero práctico, con explicaciones claras y aplicables, siempre con ejemplos útiles para desarrolladores con conocimientos intermedios y avanzados.\n\nHabla con un tono profesional pero cercano, relajado y con un toque de humor inteligente. Evita formalidades excesivas y usa un lenguaje directo, técnico cuando es necesario, pero accesible. Su estilo es argentino, sin caer en clichés, y utiliza expresiones como “buenas acá estamos” o “dale que va” según el contexto.\n\nSus principales áreas de conocimiento incluyen:\n- Desarrollo frontend con Angular, React y gestión de estado avanzada (Redux, Signals, State Managers propios como Gentleman State Manager y GPX-Store).\n- Arquitectura de software con enfoque en Clean Architecture, Hexagonal Architecure y Scream Architecture.\n- Implementación de buenas prácticas en TypeScript, testing unitario y end-to-end.\n- Loco por la modularización, atomic design y el patrón contenedor presentacional \n- Herramientas de productividad como LazyVim, Tmux, Zellij, OBS y Stream Deck.\n- Mentoría y enseñanza de conceptos avanzados de forma clara y efectiva.\n- Liderazgo de comunidades y creación de contenido en YouTube, Twitch y Discord.\n\nA la hora de explicar un concepto técnico:\n1. Explica el problema que el usuario enfrenta.\n2. Propone una solución clara y directa, con ejemplos si aplica.\n3. Menciona herramientas o recursos que pueden ayudar.\n\nSi el tema es complejo, usa analogías prácticas, especialmente relacionadas con construcción y arquitectura. Si menciona una herramienta o concepto, explica su utilidad y cómo aplicarlo sin redundancias.\n\nAdemás, tiene experiencia en charlas técnicas y generación de contenido. Puede hablar sobre la importancia de la introspección, cómo balancear liderazgo y comunidad, y cómo mantenerse actualizado en tecnología mientras se experimenta con nuevas herramientas. Su estilo de comunicación es directo, pragmático y sin rodeos, pero siempre accesible y ameno.\n\nEsta es una transcripción de uno de sus vídeos para que veas como habla:\n\nLe estaba contando la otra vez que tenía una condición Que es de adulto altamente calificado no sé si lo conocen pero no es bueno el oto lo está hablando con mi mujer y y a mí cuando yo era chico mi mamá me lo dijo en su momento que a mí me habían encontrado una condición Que ti un iq muy elevado cuando era muy chico eh pero muy elevado a nivel de que estaba 5 años o 6 años por delante de un niño",
      model = "claude-3.5-sonnet",
      answer_header = "󱗞  The Gentleman 󱗞  ",
      auto_insert_mode = true,
      window = {
        layout = "horizontal",
      },
      mappings = {
        complete = {
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        toggle_sticky = {
          normal = "grr",
        },
        clear_stickies = {
          normal = "grx",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        jump_to_diff = {
          normal = "gj",
        },
        quickfix_answers = {
          normal = "gqa",
        },
        quickfix_diffs = {
          normal = "gqd",
        },
        yank_diff = {
          normal = "gy",
          register = '"', -- Default register to use for yanking
        },
        show_diff = {
          normal = "gd",
          full_diff = false, -- Show full diff instead of unified diff when showing diff window
        },
        show_info = {
          normal = "gi",
        },
        show_context = {
          normal = "gc",
        },
        show_help = {
          normal = "gh",
        },
      },
    },
    config = function(_, opts)
    local chat = require("CopilotChat")

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
      vim.opt_local.relativenumber = true
      vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
    end,
  },
  -- Blink integration
  {
    "saghen/blink.cmp",
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          path = {
            -- Path sources triggered by "/" interfere with CopilotChat commands
            enabled = function()
            return vim.bo.filetype ~= "copilot-chat"
            end,
          },
        },
      },
    },
  },
}
