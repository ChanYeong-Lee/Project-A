using Cinemachine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Security.Claims;
using System.Xml.Serialization;
using UnityEngine;

public class CharacterAttack : MonoBehaviour
{
    private bool prepared = true;
    private bool equipArrow = false;

    public enum AttackState
    {
        Wait,
        Aiming,
    }

    private AttackState state;

    [SerializeField] private Define.AttributeType arrowAttribute;
    [SerializeField] private Transform arrowPos;
    [SerializeField] private Transform quiver;
    [SerializeField] private List<ArrowAction> arrowPrefabs;
    [SerializeField] private float chargeTime = 2.0f;
    
    [SerializeField] private AimTarget aimTarget;

    private ArrowAction arrowAction;
    private Animator animator;
    private AttackPoint target;

    private float releaseTimeout = 0.25f;
    private float releaseTimeoutDelta = 0.0f;
    private float chargedAmount = 0.0f;

    private bool release;
    private RaycastHit hit;

    // Properties
    public AttackState State => state;
    public Define.AttributeType ArrowAttribute => arrowAttribute;
    public ArrowAction ArrowAction => arrowAction;

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    private void Start()
    {
        Managers.UI.HUDUI.ArrowPanel.ChangeAttribute(arrowAttribute);
    }

    private void Update()
    {
        CheckPrepared();
        CheckTarget();
        UpdateAimTarget();
        CheckArrow();
        CheckChangeArrow();
        UpdateHUD();

        switch (state)
        {
            case AttackState.Wait:
                WaitUpdate();
                break;
            case AttackState.Aiming:
                AimingUpdate();
                break;
        }

        animator.SetInteger("AimState", (int)state);
    }

    // 화살 바꾸기
    public void ChangeArrow(Define.AttributeType attribute)
    {
        if (arrowAction.Arrow.Attribute != attribute)
        {
            arrowAttribute = attribute;

            ArrowAction newArrowAction = GenerateArrow(attribute);
            newArrowAction.transform.parent = arrowAction.transform.parent;
            newArrowAction.transform.position = arrowAction.transform.position;

            Managers.Pool.Push(arrowAction.gameObject);
            Managers.UI.HUDUI.ArrowPanel.ChangeAttribute(arrowAttribute);
            arrowAction = newArrowAction;
        }
    }

    // 공격 가능 상태인지 확인
    private void CheckPrepared()
    {
        Vector3 aimForward = aimTarget.transform.position - transform.position;
        aimForward.y = 0.0f;
        aimForward.Normalize();

        float angle = Vector3.Angle(aimForward, transform.forward);

        bool forwardCheck = angle < 140.0f;
        bool timeCheck = releaseTimeoutDelta < 0.0f;

        prepared = forwardCheck && timeCheck;
    }

    // 타겟 있는지 확인
    private void CheckTarget()
    {
        target = null;

        if (Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 100.0f))
        {
            if (hit.collider.TryGetComponent(out AttackPoint attackPoint))
            {
                target = attackPoint;
            }
        }
    }

    // 조준점 업데이트
    private void UpdateAimTarget()
    {
        if (target != null)
        {
            aimTarget.SetTarget(target.transform);
        }
        else
        {
            aimTarget.SetTarget(null);
        }

        float offset = Mathf.Lerp(10.0f, 0.0f, chargedAmount);
        aimTarget.SetAngle(offset);
    }

    // 화살이 있는지 확인
    private void CheckArrow()
    {
        if (arrowAction == null)
        {
            arrowAction = GenerateArrow(arrowAttribute);
        }
    }

    private void CheckChangeArrow()
    {
        if (Managers.Input.rightClick && !Managers.UI.IsOpenedUI && Managers.Game.Player.GetComponent<Player>().CurrentStat.HealthPoint > 0)
        {
            Managers.UI.HUDCanvas.GetComponentInChildren<HUDUI>().TurnOnArrowSelector();
        }
    }

    // 화살 생성
    private ArrowAction GenerateArrow(Define.AttributeType attribute)
    {
        var arrowData = Managers.Game.Inventory.ItemDataDic.FirstOrDefault(pair => pair.Key.ItemType == Define.ItemType.Arrow &&
            ((Arrow)pair.Key).Attribute == attribute);

        if (arrowData.Value <= 0)
        {
            attribute = Define.AttributeType.Default;
            arrowAttribute = attribute;
        }
        
        ArrowAction arrowActionPrefab = arrowPrefabs.Find((a) => a.Arrow.Attribute == attribute);
        ArrowAction arrowAction = Managers.Pool.Pop(arrowActionPrefab.gameObject).GetComponent<ArrowAction>();
        arrowAction.transform.parent = quiver;
        arrowAction.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        arrowAction.gameObject.SetActive(true);
        
        print($"Generate {attribute.ToString()} arrow");

        return arrowAction;
    }
    private void UpdateHUD()
    {
        //TODO : HUD update
        Managers.UI.HUDUI.AimUI.SetChargedAmount(chargedAmount);
        if (target != null)
        {
            Managers.UI.HUDUI.AimUI.SetTarget(target.transform);
        }
        else
        {
            Managers.UI.HUDUI.AimUI.SetTarget(null);
        }
    }

    private void WaitUpdate()
    {
        chargedAmount = 0.0f;

        if (0.0f <= releaseTimeoutDelta)
        {
            releaseTimeoutDelta -= Time.deltaTime;
        }

        if (prepared && Managers.Input.leftClick)
        {
            state = AttackState.Aiming;
        }
    }
 

    private void AimingUpdate()
    {

        if (equipArrow == false /*&& Vector3.Distance(arrow.transform.position, arrowPos.transform.position) < 10.0f*/)
        {
            arrowAction.transform.parent = arrowPos;
            arrowAction.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }

        equipArrow = arrowAction.transform.parent == arrowPos;

        chargedAmount += Time.deltaTime / chargeTime;
        chargedAmount = Mathf.Clamp(chargedAmount, 0.0f, 1.0f);

        

        if (prepared == false)
        {
            arrowAction.transform.parent = quiver;
            arrowAction.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);

            releaseTimeoutDelta = releaseTimeout;
            state = AttackState.Wait;
        }

        if (Managers.Input.leftClick == false)
        {
            if (1.00f == chargedAmount)
            {
                ReleaseArrow();
            }
            else
            {
                arrowAction.transform.parent = quiver;
                arrowAction.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
            }
            
            releaseTimeoutDelta = releaseTimeout;
            state = AttackState.Wait;
        }
    }

    private void ReleaseArrow()
    {
        if (target != null && Managers.Game.Inventory.TryUseItem(arrowAction.Arrow))
        {
            arrowAction.transform.parent = null;
            arrowAction.Shot(target);
            arrowAction = null;
            Managers.UI.HUDUI.ArrowPanel.ChangeAttribute(arrowAttribute);
            animator.SetTrigger("Release");
        }
        else
        {
            arrowAction.transform.parent = quiver;
            arrowAction.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }
    }
}
