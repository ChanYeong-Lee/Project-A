using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPanel : UIBase
{
    [SerializeField] private Image[] arrowImages;

    private Sprite defaultArrowIcon;

    private void Start()
    {
        defaultArrowIcon = Managers.Game.Inventory.ItemDataDic.FirstOrDefault(pair => pair.Value == -1).Key.Icon;
    }

    public void ChangeAttribute(Define.AttributeType attribute)
    {
        var arrowData = Managers.Game.Inventory.ItemDataDic.FirstOrDefault(pair => pair.Key.ItemType == Define.ItemType.Arrow &&
            ((Arrow)pair.Key).Attribute == attribute);

        if (arrowData.Value <= 0)
        {
            images["ArrowImage(Default)"].sprite = Managers.Game.Inventory.ItemDataDic.FirstOrDefault(pair => pair.Value == -1).Key.Icon;
            texts["ArrowNameText"].text = "기본화살";
            texts["ArrowAmountText"].text = "∞";
        }
        else
        {
            images["ArrowImage(Default)"].sprite = arrowData.Key.Icon;
            texts["ArrowNameText"].text = $"{arrowData.Key.ItemName}";
            texts["ArrowAmountText"].text = $"{arrowData.Value}";
        }
        
        // for (int i = 0; i < arrowImages.Length; i++)
        // {
        //     if (i == (int)attribute)
        //     {
        //         var itemData = Managers.Game.Player.GetComponentInChildren<Inventory>().ItemDataDic.FirstOrDefault(pair =>
        //    pair.Key.ItemType == Define.ItemType.Arrow && ((ArrowData)pair.Key).Attribute == attribute);
        //
        //         arrowImages[i].gameObject.SetActive(true);
        //
        //         if (i == 0)
        //         {
        //             texts["ArrowAmountText"].text = "∞";
        //         }
        //         else
        //         {
        //             texts["ArrowAmountText"].text = $"{itemData.Value}개";
        //             texts["ArrowNameText"].text = itemData.Key.ItemName;
        //         }
        //     }
        //     else
        //     {
        //         arrowImages[i].gameObject.SetActive(false);
        //     }
        // }
    }

}
