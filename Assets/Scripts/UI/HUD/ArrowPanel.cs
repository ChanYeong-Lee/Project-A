using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPanel : UIBase
{
    private Define.AttributeType attribute;
    [SerializeField] private Image[] arrowImages;

    private void Update()
    {
        attribute = Managers.Game.Player.GetComponent<CharacterAttack>().ArrowAttribute;

        for (int i = 0; i < arrowImages.Length; i++)
        {
            if (i == (int)attribute)
            {
                var itemData = Managers.Game.Player.GetComponentInChildren<Inventory>().ItemDataDic.FirstOrDefault(pair =>
           pair.Key.ItemType == Define.ItemType.Arrow && ((ArrowData)pair.Key).Attribute == attribute);
                
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
