using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UISettings : ContentElement
{
    protected override void Awake()
    {
        base.Awake();
        
        buttons["Back"].onClick.AddListener(() => Managers.UI.CloseMainUI());
        buttons["Exit"].onClick.AddListener(() => Managers.Game.ExitGame());
    }
}
