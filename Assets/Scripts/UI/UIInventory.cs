using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class UIInventory : ContentElement
{
    private List<UISlot> slots = new List<UISlot>();

    [SerializeField] private RectTransform content;
    [SerializeField] private GameObject itemInfo;
    
    private Inventory inventory;
    private UISlot slotPrefab;
    private UISlot selectSlot;
    private UISlot focusedSlot;

    public UISlot SelectSlot { get => selectSlot; set => selectSlot = value; }

    protected override void Awake()
    {
        base.Awake();
    }

    private void OnEnable()
    {
        if (inventory == null) 
            inventory = Managers.Game.Player.GetComponentInChildren<Inventory>();
        
        buttons["All"].onClick.AddListener(() => UpdateInventory(Define.ItemType.None));
        buttons["Arrows"].onClick.AddListener(() => UpdateInventory(Define.ItemType.Arrow));
        buttons["Consumptions"].onClick.AddListener(() => UpdateInventory(Define.ItemType.Consumption));
        buttons["Ingredients"].onClick.AddListener(() => UpdateInventory(Define.ItemType.Ingredients));
        
        UpdateInventory();
    }

    private void Update()
    {
        if (selectSlot == null)
        {
            if (slots.Count == 0)
                return;

            selectSlot = slots[0];
        }
            
        UpdateItemInfo(selectSlot);
    }

    // 정렬할 itemType을 넣으면 정렬
    // None이면 전체
    public void UpdateInventory(Define.ItemType itemType = Define.ItemType.None)
    {
        foreach (UISlot slot in slots) 
            Managers.Pool.Push(slot.gameObject);
        
        slots.Clear();

        int i = 0;
        foreach (var item in inventory.ItemDataDic)
        {
            if (itemType != Define.ItemType.None && itemType != item.Key.ItemType)
                continue;
            
            var slot = Managers.Resource.Instantiate("Prefabs/UI/InventorySlot", content.transform, true).GetComponent<UISlot>();
            
            slot.transform.SetSiblingIndex(i++);
            slot.SlotType = SlotType.InventoryMenu;
            slots.Add(slot);
            slot.ItemData = item.Key;
            
            slot.Images["Icon"].sprite = slot.ItemData.Icon;
            slot.Texts["NameText"].text = $"{item.Key.ItemName}";
            slot.Texts["TypeText"].text = $"{item.Key.ItemTypeName}";
            slot.Texts["AmountText"].text = $"{item.Value}";
        }
    }

    private void UpdateItemInfo(UISlot slot)
    {
        images["IconImage"].sprite = slot.ItemData.Icon;
        texts["AmountLabelText"].text = $"{inventory.ItemDataDic.GetValueOrDefault(slot.ItemData, 0)}";
        texts["NameText"].text = $"{slot.ItemData.ItemName}";
        texts["DescriptionText"].text = $"{slot.ItemData.Description}";
        texts["TypeText"].text = $"{slot.ItemData.ItemTypeName}";
    }
}