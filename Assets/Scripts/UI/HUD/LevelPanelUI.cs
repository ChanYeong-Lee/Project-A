using System;
using UnityEngine;

public class LevelPanelUI : UIBase
{
    private void Start()
    {
        UpdateLevel(Managers.Game.Player.GetComponent<Player>().CurrentLevel);
    }

    public void UpdateLevel(int level)
    {
        texts["LevelText"].text = $"Lv.{level}";
    }
}