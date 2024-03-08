using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class HUDUI : MonoBehaviour
{
    [SerializeField] private AimUI aimUI;
    [SerializeField] private ItemPanel itemPanel;
    [SerializeField] private HealthBar healthBar;
    [SerializeField] private HealthBar bossHealthBar;
    [SerializeField] private CompassUI compass;
    [SerializeField] private GameObject gameOverUI;
    [SerializeField] private ArrowSelector arrowSelector;
    [SerializeField] private ArrowPanel arrowPanel;

    public AimUI AimUI => aimUI;
    public ArrowPanel ArrowPanel => arrowPanel;
    public HealthBar BossHealthBar => bossHealthBar;
    public GameObject GameOverUI => gameOverUI;

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
