using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemPanel : UIBase
{
    private string[] potions;

    private void Start()
    {
        potions = new[] { "SmallPotion", "MediumPotion", "LargePotion" };
    }

    private void Update()
    {
        UpdateItemSlot();
    }

    public void UpdateItemSlot()
    {
        for (int i = 0; i < 3; i++)
        {
            texts[$"AmountLabelText{i}"].text = $"{Managers.Game.Inventory.GetItemCount(potions[i])}";
        }
    }
}
