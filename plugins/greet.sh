#!/bin/bash

#greet

CmdAdd 'Com_greet' 'Показать приветствие' 'greet' 'motd'
Com_greet()
{
  Com_upsolid
  Com_textline "Добро пожаловать в систему консольного доступа “LORA” v. 0.1"
  Com_downsolid
}

# Алгоритм смены версий:
# Milestone 1 (Tracker blow out) - 0.1
# Milestone 2 (Profile peeper) - 0.2
# Milestone 3 (Tropic topic) - 0.3
# Milestone 4 (Answer me, I'm listening) - 0.4
# После завершения Milestone 4 - 1.x

