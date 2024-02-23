using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class UIInventory : UIBase
{
    private List<UISlot> slots = new List<UISlot>();

    // TODO : 인벤토리 참조는 Managers.Game.Player.inventory로 바꾸기
    [SerializeField] private Inventory inventory;
    [SerializeField] private RectTransform content;
    [SerializeField] private UISlot slotPrefab;
    [SerializeField] private GameObject itemInfo;
    
    private UISlot selectSlot;
    private UISlot focusedSlot;

    public UISlot SelectSlot { get => selectSlot; set => selectSlot = value; }
    
    private void OnEnable()
    {
        foreach (UISlot slot in slots)
        {
            Managers.Pool.Push(slot.gameObject);
        }
        
        slots.Clear();
        
        foreach (var item in inventory.ItemDataDic)
        {
            var slot = Managers.Pool.Pop(slotPrefab.gameObject, content).GetComponent<UISlot>();

            slot.SlotType = SlotType.InventoryMenu;
            slots.Add(slot);
            slot.ItemData = item.Key;
            slot.Text.text = $"{item.Key.ItemName} X{item.Value}";
        }
    }

    private void Update()
    {
        if (selectSlot == null)
            return;

        UpdateItemInfo(selectSlot);
    }

    private void UpdateItemInfo(UISlot slot)
    {
        itemInfo.GetComponentInChildren<TextMeshProUGUI>().text = slot.ItemData.ItemName;
        // itemInfo.GetComponentInChildren<Image>().sprite = slot.ItemData.
    }
}