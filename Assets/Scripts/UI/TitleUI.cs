using System;

public class TitleUI : UIBase
{
    private void Start()
    {
        buttons["StartGame"].onClick.AddListener(() => Managers.Scene.LoadScene(Define.SceneType.GameScene));
        // buttons["GameSettings"].onClick.AddListener(() => ());
        buttons["ExitGame"].onClick.AddListener(() => Managers.Game.ExitGame());
    }
}