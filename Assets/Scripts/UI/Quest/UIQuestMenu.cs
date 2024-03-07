using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using TMPro;

public class UIQuestMenu : ContentElement 
{
    private Inventory inventory;
    private UISlot slotPrefab;
    private UISlot selectSlot;

    private List<QuestInfoSo> questInfoList = new();


    private void OnEnable()
    {
       
    }

}
