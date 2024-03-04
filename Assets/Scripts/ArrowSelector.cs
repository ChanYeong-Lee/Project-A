using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ArrowSelector : MonoBehaviour 
{
    [SerializeField] private List<ArrowSlot> slots;
    [SerializeField] private Image centerIndicator;
    
    private Vector3 screenCenter;
    private float centerRadius;
    private ArrowSlot focusSlot;
    private ArrowSlot prevSlot;

    private void Awake()
    {
        screenCenter = new Vector3(Screen.width * 0.5f, Screen.height * 0.5f, 0.0f);
        centerRadius = centerIndicator.rectTransform.rect.width / 2.0f;
    }


    private void Update()
    {
        Vector3 mousePos = Input.mousePosition;

        if (centerRadius < Vector3.Distance(screenCenter, mousePos))
        {
            float angle = Mathf.Atan2(mousePos.y - screenCenter.y, mousePos.x - screenCenter.x) * Mathf.Rad2Deg;

            if (angle < 0.0f)
            {
                angle = 360.0f + angle;
            }

            if (angle < 90.0f)
            {
                angle = 90.0f - angle;
            }
            else
            {
                angle = 450.0f - angle;
            }

            int index = (int)(angle / 45.0f);

            if (6 < index)
            {
                index = 0;
            }

            if (focusSlot != null && focusSlot != slots[index])
            {
                focusSlot.FocusSlot(false);
            }
            focusSlot = slots[index];
            focusSlot.FocusSlot(true);
        }
        else
        {
            if (focusSlot != null)
            {
                focusSlot.FocusSlot(false);
                focusSlot = null;
            }
        }
    }

    public void SelectArrow()
    {
        // TODO : 플레이어의 현재 화살을 선택된 화살로 바꿈.
    }
}
