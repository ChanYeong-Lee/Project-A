﻿using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class UIInventory : ContentElement
{
    private List<UISlot> slots = new List<UISlot>();

    [SerializeField] private RectTransform content;
    
    private Inventory inventory;
    private UISlot slotPrefab;
    private UISlot selectedSlot;
    private UISlot focusedSlot;
    private Button selectedSortingButton;

    public UISlot SelectedSlot { get => selectedSlot; set => selectedSlot = value; }

    protected override void Awake()
    {
        base.Awake();
        
        if (inventory == null)
            inventory = Managers.Game.Inventory;

        BindButtons();
    }

    private void OnEnable()
    {
        UpdateInventory();
        selectedSortingButton = buttons["All"];
    }

    private void Update()
    {
        ChangeSelectedSlot(Managers.Input.MoveUI);
        ChangeSortingSlot(Managers.Input.SortingMoveUI);
        UpdateItemInfo(selectedSlot);
    }

    private void BindButtons()
    {
        buttons["All"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["All"];
            UpdateInventory(Define.ItemType.None);
        });
        buttons["Arrows"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["Arrows"];
            UpdateInventory(Define.ItemType.Arrow);
        });
        buttons["Consumptions"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["Consumptions"];
            UpdateInventory(Define.ItemType.Consumption);
        });
        buttons["Ingredients"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["Ingredients"];
            UpdateInventory(Define.ItemType.Ingredients);
        });
    }

    // 정렬할 itemType을 넣으면 정렬
    // None이면 전체
    private void UpdateInventory(Define.ItemType itemType = Define.ItemType.None)
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
            slot.Item = item.Key;
            
            slot.Images["Icon"].sprite = slot.Item.Icon;
            slot.Texts["NameText"].text = $"{item.Key.ItemName}";
            slot.Texts["TypeText"].text = $"{item.Key.ItemTypeName}";
            slot.Texts["AmountText"].text = $"{inventory.GetItemCount(item.Key)}";
        }
        
        if (slots.Count == 0)
            return;
        
        selectedSlot = content.transform.GetComponentInChildren<UISlot>();
        selectedSlot.ChangeAlpha(1f);
    }

    private void UpdateItemInfo(UISlot slot)
    {
        if (slot == null)
            return;
        
        images["IconImage"].sprite = slot.Item.Icon;
        texts["AmountLabelText"].text = $"{inventory.GetItemCount(slot.Item)}";
        texts["NameText"].text = $"{slot.Item.ItemName}";
        texts["DescriptionText"].text = $"{slot.Item.Description}";
        texts["TypeText"].text = $"{slot.Item.ItemTypeName}";
    }
    
    public void ChangeSelectedSlot(float value)
    {
        int i = slots.IndexOf(selectedSlot);

        if (i == -1)
            return;
        
        if (value > 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[(i + 1) % slots.Count];
        }
        else if (value < 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[i - 1 < 0 ? slots.Count - 1 : i - 1];
        }
        else
            return;
        
        selectedSlot.ChangeAlpha(1f);
    }
    
    public void ChangeSortingSlot(float value)
    {
        if (value < 0)
        {
            if (selectedSortingButton == buttons["All"])
            {
                buttons["Arrows"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Arrows"])
            {
                buttons["Consumptions"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Consumptions"])
            {
                buttons["Ingredients"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Ingredients"])
            {
                buttons["All"].onClick.Invoke();
            }
        }
        else if (value > 0)
        {
            if (selectedSortingButton == buttons["All"])
            {
                buttons["Ingredients"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Arrows"])
            {
                buttons["All"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Consumptions"])
            {
                buttons["Arrows"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Ingredients"])
            {
                buttons["Consumptions"].onClick.Invoke();
            }
        }
    }
}