using Cinemachine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
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
    [SerializeField] private List<Arrow> arrowPrefabs;
    [SerializeField] private float chargeTime = 2.0f;
    
    [SerializeField] private AimTarget aimTarget;

    private Arrow arrow;
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
    public Arrow Arrow => arrow;

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    private void Start()
    {
        Managers.UI.HUD.GetComponentInChildren<HUDUI>().ArrowPanel.ChangeAttribute(arrowAttribute);
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
        if (arrow.ArrowData.Attribute != attribute)
        {
            arrowAttribute = attribute;

            Arrow newArrow = GenerateArrow(attribute);
            newArrow.transform.parent = arrow.transform.parent;
            newArrow.transform.position = arrow.transform.position;

            Managers.Pool.Push(arrow.gameObject);
            Managers.UI.HUD.GetComponentInChildren<HUDUI>().ArrowPanel.ChangeAttribute(arrowAttribute);
            arrow = newArrow;
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
        if (arrow == null)
        {
            arrow = GenerateArrow(arrowAttribute);
        }
    }

    private void CheckChangeArrow()
    {
        if (Managers.Input.rightClick)
        {
            Managers.UI.HUD.GetComponentInChildren<HUDUI>().TurnOnArrowSelector();
        }
    }

    // 화살 생성
    private Arrow GenerateArrow(Define.AttributeType attribute)
    {
        Arrow arrowPrefab = arrowPrefabs.Find((a) => a.ArrowData.Attribute == attribute);
        Arrow arrow = Managers.Pool.Pop(arrowPrefab.gameObject).GetComponent<Arrow>();
        arrow.transform.parent = quiver;
        arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        arrow.gameObject.SetActive(true);
        
        print($"Generate {attribute.ToString()} arrow");

        return arrow;
    }
    private void UpdateHUD()
    {
        //TODO : HUD update
        Managers.UI.HUD.GetComponentInChildren<HUDUI>().AimUI.SetChargedAmount(chargedAmount);
        if (target != null)
        {
            Managers.UI.HUD.GetComponentInChildren<HUDUI>().AimUI.SetTarget(target.transform);
        }
        else
        {
            Managers.UI.HUD.GetComponentInChildren<HUDUI>().AimUI.SetTarget(null);
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
            arrow.transform.parent = arrowPos;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }

        equipArrow = arrow.transform.parent == arrowPos;

        chargedAmount += Time.deltaTime / chargeTime;
        chargedAmount = Mathf.Clamp(chargedAmount, 0.0f, 1.0f);

        

        if (prepared == false)
        {
            arrow.transform.parent = quiver;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);

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
                arrow.transform.parent = quiver;
                arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
            }
            
            releaseTimeoutDelta = releaseTimeout;
            state = AttackState.Wait;
        }
    }

    private void ReleaseArrow()
    {
        if (target != null)
        {
            arrow.transform.parent = null;
            arrow.Shot(target);
            arrow = null;

            animator.SetTrigger("Release");
        }
        else
        {
            arrow.transform.parent = quiver;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }
    }
}
