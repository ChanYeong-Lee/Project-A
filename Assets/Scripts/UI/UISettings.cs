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
        buttons["Title"].onClick.AddListener(() =>
        {
            Managers.Clear();
            Managers.Scene.LoadScene(Define.SceneType.TitleScene);
        });
        buttons["Exit"].onClick.AddListener(() => Managers.Game.ExitGame());
    }
    
    // TODO : 사운드 설정 받기
}
