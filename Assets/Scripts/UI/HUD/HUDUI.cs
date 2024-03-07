using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUDUI : MonoBehaviour
{
    [SerializeField] private AimUI aimUI;
    [SerializeField] private ItemPanel itemPanel;
    [SerializeField] private HealthBar healthBar;
    [SerializeField] private HealthBar bossHelathBar;
    [SerializeField] private CompassUI compass;
    [SerializeField] private GameObject gameOverUI;
    [SerializeField] private ArrowSelector arrowSelector;

    public AimUI AimUI => aimUI;

    public void TurnOnArrowSelector()
    {
        Managers.Cursor.ChangeCursorState(CursorManager.CursorState.UI);
        arrowSelector.gameObject.SetActive(true);
    }

    public void GameOver()
    {
        gameOverUI.SetActive(true);
    }
}
