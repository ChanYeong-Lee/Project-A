using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CompassUI : MonoBehaviour
{
    [SerializeField] private float numberOfPixelsNorthToNorth;
    [SerializeField] private RectTransform indicator;
    [SerializeField] private GameObject target;

    private Vector3 startPos;
    private float rationAngleToPixel;

    //void Start()
    //{
    //    if (target == null) 
    //        target = GameObject.Find("CamTarget");
        
    //    startPos = indicator.position;
    //    rationAngleToPixel = numberOfPixelsNorthToNorth / 360.0f;
    //}

    //void Update()
    //{
    //    Vector3 perp = Vector3.Cross(Vector3.forward, target.transform.forward);
    //    float dir = Vector3.Dot(perp, Vector3.up);
    //    indicator.position = startPos + (new Vector3(Vector3.Angle(target.transform.forward, Vector3.forward) * Mathf.Sign(dir) * rationAngleToPixel, 0, 0));
    //}
}
