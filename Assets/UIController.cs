using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIController : MonoBehaviour
{
    [SerializeField] private PlayerInputAsset input;
    private bool uiOpen;
    private void Update()
    {
        if (input.esc)
        {
            if (uiOpen)
            {
                Managers.UI.CloseMainUI();
                uiOpen = false; 
            }
            else
            {
                Managers.UI.OpenMainUI();
                uiOpen = true; 
            }
        }
    }
}
