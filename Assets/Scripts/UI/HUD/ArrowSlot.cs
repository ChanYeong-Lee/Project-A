using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class ArrowSlot : UIBase
{
    [SerializeField] private Define.AttributeType attribute;
    public Define.AttributeType Attribute => attribute;

    private void Update()
    {
        var itemData = Managers.Game.Inventory.ItemDataDic.FirstOrDefault(pair =>
            pair.Key.ItemType == Define.ItemType.Arrow &&
            ((ArrowData)pair.Key).Attribute == attribute);
        
        UpdateArrowSlot(itemData.Value);
    }

    public void UpdateArrowSlot(int amount)
    {
        if (attribute == Define.AttributeType.Default)
        {
            images["ArrowImage"].color = ColorHelper.SetColorAlpha(images["ArrowImage"].color, 1.0f);
            texts["AmountText"].text = "¡Ä";
            return;
        }
        
        if (amount == 0)
        {
            images["ArrowImage"].color = ColorHelper.SetColorAlpha(images["ArrowImage"].color, 0.2f);
            texts["AmountText"].text = $"{amount}°³";
        }
        else
        {
            images["ArrowImage"].color = ColorHelper.SetColorAlpha(images["ArrowImage"].color, 1.0f);
            texts["AmountText"].text = $"{amount}°³";
        }
    }

    
    public void FocusSlot(bool focus)
    {
        if (focus)
        {
            images["Label"].color = ColorHelper.SetColorAlpha(images["Label"].color, 1.0f);
        }
        else
        {
            images["Label"].color = ColorHelper.SetColorAlpha(images["Label"].color, 0.2f);
        }
    }
}
