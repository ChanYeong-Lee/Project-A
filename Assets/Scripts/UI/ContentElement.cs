using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContentElement : UIBase
{
    [SerializeField] private MenuType type;
    private RectTransform rect;

    public MenuType Type => type;
    public RectTransform Rect => Rect;
    
    private void Awake()
    {
        rect = GetComponent<RectTransform>();
    }
}