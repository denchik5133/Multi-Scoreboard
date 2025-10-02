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
 *                  GitHub: 
 *                
 *   @description   Multi scoreboard is a modern, minimalistic scoreboard with a user—friendly interface and a set of functional utilities for effective administration.
 *                  All the necessary tools and quick access to information allow administrators to easily control the gameplay and quickly execute commands.
 *
 *   @usage         !danlibmenu (chat) | danlibmenu (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */



local ENGLISH = {
    ['MS#CurrentPlayers'] = 'Current Players ({color:blue}{pcount}{/color:})',

    ['MS#Nick'] = 'Name',
    ['MS#Level'] = 'Level',
    ['MS#Jobs'] = 'Jobs',
    ['MS#Rank'] = 'Rank',
    ['MS#Ping'] = 'Ping',

    ['MS#You'] = '{nick} ( {color:blue}You{/color:} )',
    ['MS#Friend'] = '{nick} ( {color:blue}Friend{/color:} )',

    ['MS#PlayerOut'] = 'The player is out.',

    -- ADMINS
    ['MS#BanTime'] = 'Enter the ban time for {color:blue}{name}{/color:} in minutes.',
    ['MS#BanReason'] = 'Enter the reason for banning player {color:blue}{name}{/color:} for {color:255,165,0}{time}{/color:} minutes(s).',
    ['MS#KickReason'] = 'Enter the reason for kicking player {color:blue}{name}{/color:}'
}
DanLib.Func.RegisterLanguage('English', ENGLISH)
