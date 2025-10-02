/***
 *   @addon         Scoreboard
 *   @version       1.0.0
 *   @release_date  16/09/2025
 *   @author        denchik
 *   @contact       Discord: denchik_gm
 *                  Steam: https://steamcommunity.com/profiles/76561198405398290/
 *                  GitHub: https://github.com/denchik5133
 *
 *   @script        Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=2522126872
 *                  GitHub: https://github.com/denchik5133/Multi-Scoreboard
 *                
 *   @description   Multi scoreboard is a modern, minimalistic scoreboard with a user—friendly interface and a set of functional utilities for effective administration.
 *                  All the necessary tools and quick access to information allow administrators to easily control the gameplay and quickly execute commands.
 *
 *   @usage         !danlibmenu (chat) | danlibmenu (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */



local RUSSIAN = {
    ['MS#CurrentPlayers'] = 'Current Players ({color:blue}{pcount}{/color:})',

    ['MS#Nick'] = 'Имя',
    ['MS#Level'] = 'Уровень',
    ['MS#Jobs'] = 'Работа',
    ['MS#Rank'] = 'Ранг',
    ['MS#Ping'] = 'Пинг',

    ['MS#You'] = '{nick} ( {color:blue}Вы{/color:} )',
    ['MS#Friend'] = '{nick} ( {color:blue}Друг{/color:} )',

    ['MS#PlayerOut'] = 'Игрок вышел из игры.',

    -- ADMINS
    ['MS#BanTime'] = 'Введите время запрета для {color:blue}{name}{/color:} в минутах.',
    ['MS#BanReason'] = 'Введите причину блокировки игрока {color:blue}{name}{/color:} на {color:255,165,0}{time}{/color:} минут(ы).',
    ['MS#KickReason'] = 'Укажите причину, по которой игрок был выгнан {color:blue}{name}{/color:}'
}
DanLib.Func.RegisterLanguage('Russian', RUSSIAN)
