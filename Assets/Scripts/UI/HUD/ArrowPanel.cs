using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPanel : UIBase
{
    [SerializeField] private Image[] arrowImages;

    public void ChangeAttribute(Define.AttributeType attribute)
    {
        for (int i = 0; i < arrowImages.Length; i++)
        {
            if (i == (int)attribute)
            {
                var itemData = Managers.Game.Player.GetComponentInChildren<Inventory>().ItemDataDic.FirstOrDefault(pair =>
           pair.Key.ItemType == Define.ItemType.Arrow && ((ArrowData)pair.Key).Attribute == attribute);

                //texts["ArrowNameText"].text = itemData.Key.ItemName;
                arrowImages[i].gameObject.SetActive(true);

                if (i == 0)
                {
                    texts["ArrowAmountText"].text = "¡Ä";
                }
                else
                {
                    texts["ArrowAmountText"].text = $"{itemData.Value}°³";
                }
            }
            else
            {
                arrowImages[i].gameObject.SetActive(false);
            }
        }
    }

}
