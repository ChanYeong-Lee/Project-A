using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class UIInventory : MonoBehaviour
{
    private List<UIInvenSlot> slots = new List<UIInvenSlot>();

    // TODO : 인벤토리 참조는 Managers.Game.Player.inventory로 바꾸기
    [SerializeField] private Inventory inventory;
    [SerializeField] private RectTransform content;
    [SerializeField] private UIInvenSlot slotPrefab;
    [SerializeField] private GameObject itemInfo;
    private int slotCount;
    private UISlot selectSlot;
    private UISlot focusedSlot;

    public UISlot SelectSlot { get => selectSlot; set => selectSlot = value; }
    
    private void OnEnable()
    {
        foreach (UIInvenSlot slot in slots)
        {
            Managers.Pool.Push(slot.gameObject);
        }
        
        slots.Clear();
        
        foreach (var item in inventory.ItemDataDic)
        {
            var slot = Managers.Pool.Pop(slotPrefab.gameObject, content).GetComponent<UIInvenSlot>();
            
            slots.Add(slot);
            slot.ItemData = item.Key;
            slot.Text.text = $"{item.Key.ItemName} X{item.Value}";
        }
    }

    private void Update()
    {
        if (selectSlot == null)
            return;

        itemInfo.GetComponentInChildren<TextMeshProUGUI>().text = selectSlot.ItemData.ItemName;
    }
}