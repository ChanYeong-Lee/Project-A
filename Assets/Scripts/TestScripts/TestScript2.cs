using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;
using UnityEngine.Events;

public class TestScript2 : MonoBehaviour
{

    public bool pressed = false;

    void Update()
    {
        if (Input.GetKeyDown("b"))
        {
            pressed = !pressed;
            if(true == pressed)
            {
                Open();
            }
            if(false == pressed)
            {
                Close();
            }
            
        }
    }
   
    public void Open()
    {
        
        Managers.UI.OpenMainUI();
    }
    public void press()
    {
       
    }
    public void Close()
    {
        Managers.UI.CloseMainUI();
    }
    


}
